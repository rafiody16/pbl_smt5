import 'dart:io';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class MarketplaceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String _mlApiUrl =
      "https://rafiody16-flutter-api-integration.hf.space";

  Future<List<Map<String, dynamic>>> getProduk() async {
    try {
      final response = await _supabase
          .from('produk')
          .select('*, warga(nama_lengkap)')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchProduk(String query) async {
    try {
      final response = await _supabase
          .from('produk')
          .select('*, warga(nama_lengkap)')
          .eq('is_active', true)
          .ilike('nama_produk', '%$query%')
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mencari produk: $e');
    }
  }

  Future<String?> searchProdukByImage(File image) async {
    try {
      final uri = Uri.parse("$_mlApiUrl/predict");

      final request = http.MultipartRequest("POST", uri)
        ..files.add(await http.MultipartFile.fromPath("file", image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final jsonData = json.decode(body);

        return jsonData["prediction"];
      } else {
        throw Exception("Gagal mengenali motif batik");
      }
    } catch (e) {
      throw Exception("Visual search error: $e");
    }
  }

  Future<void> tambahProduk(Map<String, dynamic> data, File? imageFile) async {
    try {
      if (imageFile != null) {
        final imageUrl = await _uploadImage(imageFile);
        data['gambar_url'] = imageUrl;
      }
      await _supabase.from('produk').insert(data);
    } catch (e) {
      throw Exception('Gagal menambah produk: $e');
    }
  }

  Future<void> updateProduk(
    int id,
    Map<String, dynamic> data,
    File? newImageFile,
  ) async {
    try {
      if (newImageFile != null) {
        final imageUrl = await _uploadImage(newImageFile);
        data['gambar_url'] = imageUrl;
      }
      await _supabase.from('produk').update(data).eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengupdate produk: $e');
    }
  }

  Future<void> deleteProduk(int id) async {
    try {
      await _supabase.from('produk').update({'is_active': false}).eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileExt = path.extension(imageFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = 'produk_images/$fileName';

      await _supabase.storage
          .from('marketplace')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return _supabase.storage.from('marketplace').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }
}
