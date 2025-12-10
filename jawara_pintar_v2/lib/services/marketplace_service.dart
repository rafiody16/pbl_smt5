import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class MarketplaceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Mengambil semua produk (Join dengan tabel warga untuk dapat nama penjual)
  Future<List<Map<String, dynamic>>> getProduk() async {
    try {
      final response = await _supabase
          .from('produk')
          .select(
            '*, warga(nama_lengkap)',
          ) // Pastikan relasi foreign key 'seller_nik' -> 'warga.nik' ada
          .eq('is_active', true) // Hanya ambil yang aktif
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  // 2. Tambah Produk Baru
  Future<void> tambahProduk(Map<String, dynamic> data, File? imageFile) async {
    try {
      // Jika ada gambar, upload dulu
      if (imageFile != null) {
        final imageUrl = await _uploadImage(imageFile);
        data['gambar_url'] = imageUrl;
      }

      await _supabase.from('produk').insert(data);
    } catch (e) {
      throw Exception('Gagal menambah produk: $e');
    }
  }

  // 3. Update Produk
  Future<void> updateProduk(
    int id,
    Map<String, dynamic> data,
    File? newImageFile,
  ) async {
    try {
      // Jika ada gambar baru, upload dan replace URL
      if (newImageFile != null) {
        final imageUrl = await _uploadImage(newImageFile);
        data['gambar_url'] = imageUrl;
      }

      await _supabase.from('produk').update(data).eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengupdate produk: $e');
    }
  }

  // 4. Hapus Produk (Soft Delete / Set is_active false)
  Future<void> deleteProduk(int id) async {
    try {
      // Opsi 1: Hard Delete
      // await _supabase.from('produk').delete().eq('id', id);

      // Opsi 2: Soft Delete (Disarankan)
      await _supabase.from('produk').update({'is_active': false}).eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  // 5. Cari Produk (Text)
  Future<List<Map<String, dynamic>>> searchProduk(String query) async {
    try {
      final response = await _supabase
          .from('produk')
          .select('*, warga(nama_lengkap)')
          .eq('is_active', true)
          .ilike('nama_produk', '%$query%') // Case insensitive search
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mencari produk: $e');
    }
  }

  // --- Helper: Upload Image ke Supabase Storage ---
  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileExt = path.extension(imageFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = 'produk_images/$fileName';

      // Upload ke bucket 'marketplace' (Pastikan bucket ini sudah dibuat di Supabase)
      await _supabase.storage
          .from('marketplace')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Ambil Public URL
      final imageUrl = _supabase.storage
          .from('marketplace')
          .getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  // --- Placeholder: Visual Search ---
  // Karena Visual Search butuh AI/Backend khusus, ini adalah simulasi logic-nya.
  Future<List<Map<String, dynamic>>> searchProdukByImage(File image) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi loading
    return []; // Return kosong untuk sementara
  }
}
