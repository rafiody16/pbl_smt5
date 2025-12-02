import 'package:supabase_flutter/supabase_flutter.dart';

class WargaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil daftar warga (Join dengan tabel keluarga jika perlu)
  Future<List<Map<String, dynamic>>> getWarga() async {
    try {
      final response = await _supabase
          .from('warga')
          .select('*, keluarga(*)') // Mengambil data keluarga terkait
          .order('nama_lengkap');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mengambil data warga: $e');
    }
  }

  // Mengambil warga berdasarkan NIK
  Future<Map<String, dynamic>> getWargaByNik(String nik) async {
    try {
      final response = await _supabase
          .from('warga')
          .select('*, keluarga(*)')
          .eq('nik', nik)
          .single();

      return response;
    } catch (e) {
      throw Exception('Gagal mengambil data warga: $e');
    }
  }

  // Menambah warga baru
  Future<void> tambahWarga(Map<String, dynamic> data) async {
    try {
      await _supabase.from('warga').insert(data);
    } catch (e) {
      throw Exception('Gagal menambah warga: $e');
    }
  }

  // Update warga
  Future<void> updateWarga(String nik, Map<String, dynamic> data) async {
    try {
      await _supabase.from('warga').update(data).eq('nik', nik);
    } catch (e) {
      throw Exception('Gagal mengupdate warga: $e');
    }
  }

  // Hapus warga
  Future<void> deleteWarga(String nik) async {
    try {
      await _supabase.from('warga').delete().eq('nik', nik);
    } catch (e) {
      throw Exception('Gagal menghapus warga: $e');
    }
  }

  // Search warga by nama
  Future<List<Map<String, dynamic>>> searchWarga(String query) async {
    try {
      final response = await _supabase
          .from('warga')
          .select('*, keluarga(*)')
          .ilike('nama_lengkap', '%$query%')
          .order('nama_lengkap');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mencari warga: $e');
    }
  }
}
