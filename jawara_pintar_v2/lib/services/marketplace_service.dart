import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class MarketplaceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Nama bucket harus sesuai dengan yang dibuat di Dashboard Supabase
  final String _bucketName = 'produk_images';

  // --- AMBIL DATA PRODUK ---
  Future<List<Map<String, dynamic>>> getProduk() async {
    try {
      final response = await _supabase
          .from('mp_products')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  // --- TAMBAH PRODUK BARU ---
  Future<void> tambahProduk(Map<String, dynamic> data, File? imageFile) async {
    try {
      if (imageFile != null) {
        // Step 1: Upload gambar ke storage
        final imageUrl = await _uploadImage(imageFile);
        // Step 2: Tambahkan URL hasil upload ke dalam map data
        data['gambar_url'] = imageUrl;
      }

      // Step 3: Masukkan data lengkap ke tabel database
      await _supabase.from('mp_products').insert(data);
    } on PostgrestException catch (e) {
      // Error khusus database (RLS, Nama Kolom, atau Foreign Key)
      throw Exception('Database Error: ${e.message} (Hint: ${e.hint})');
    } catch (e) {
      throw Exception('Gagal menambah produk: $e');
    }
  }

  // --- UPDATE PRODUK ---
  Future<void> updateProduk(
    int id,
    Map<String, dynamic> data,
    File? imageFile,
  ) async {
    try {
      if (imageFile != null) {
        final imageUrl = await _uploadImage(imageFile);
        data['gambar_url'] = imageUrl;
      }

      await _supabase.from('mp_products').update(data).eq('id', id);
    } catch (e) {
      throw Exception('Gagal update produk: $e');
    }
  }

  // --- HAPUS PRODUK ---
  Future<void> deleteProduk(int id) async {
    try {
      await _supabase.from('mp_products').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error hapus produk: $e');
    }
  }

  // --- HELPER: PROSES UPLOAD GAMBAR ---
  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileExt = path.extension(imageFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = fileName;

      // Upload ke bucket yang benar (bukan 'marketplace')
      await _supabase.storage
          .from(_bucketName)
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Ambil Public URL untuk disimpan di kolom gambar_url database
      return _supabase.storage.from(_bucketName).getPublicUrl(filePath);
    } catch (e) {
      // Jika error di sini, kemungkinan besar Storage Policy belum diatur
      throw Exception('Gagal upload gambar ke bucket $_bucketName: $e');
    }
  }

  // --- PENCARIAN & VISUAL SEARCH ---
  Future<List<Map<String, dynamic>>> searchProduk(String query) async {
    try {
      final response = await _supabase
          .from('mp_products')
          .select()
          .ilike('nama_produk', '%$query%')
          .order('created_at');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mencari produk: $e');
    }
  }

  Future<String?> searchProdukByImage(File image) async {
    try {
      final uri = Uri.parse(
        "https://tamadio-batiknitik-classifier-dioandika.hf.space/predict",
      );
      final request = http.MultipartRequest("POST", uri)
        ..files.add(await http.MultipartFile.fromPath("file", image.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        if (body.contains('🎨')) {
          final start = body.indexOf('🎨') + 2;
          final end = body.indexOf('</div>', start);
          return body.substring(start, end).trim();
        }
        return null;
      } else {
        throw Exception("Gagal mengenali motif");
      }
    } catch (e) {
      throw Exception("Visual search error: $e");
    }
  }
}
