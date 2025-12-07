import 'package:supabase_flutter/supabase_flutter.dart';

class KeluargaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil semua data keluarga
  Future<List<Map<String, dynamic>>> getKeluarga() async {
    try {
      final response = await _supabase
          .from('keluarga')
          .select()
          .order('nama_keluarga');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mengambil data keluarga: $e');
    }
  }

  // Mengambil keluarga berdasarkan ID
  Future<Map<String, dynamic>> getKeluargaById(int id) async {
    try {
      final response = await _supabase
          .from('keluarga')
          .select()
          .eq('id', id)
          .single();

      return response;
    } catch (e) {
      throw Exception('Gagal mengambil data keluarga: $e');
    }
  }

  // Menambah keluarga baru
  Future<void> tambahKeluarga(Map<String, dynamic> data) async {
    try {
      await _supabase.from('keluarga').insert(data);
    } catch (e) {
      throw Exception('Gagal menambah keluarga: $e');
    }
  }

  // Update keluarga
  Future<void> updateKeluarga(int id, Map<String, dynamic> data) async {
    try {
      await _supabase.from('keluarga').update(data).eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengupdate keluarga: $e');
    }
  }

  // Hapus keluarga
  Future<void> deleteKeluarga(int id) async {
    try {
      await _supabase.from('keluarga').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus keluarga: $e');
    }
  }
}
