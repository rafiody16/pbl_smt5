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

  // Menambah warga baru (dengan optional user account creation)
  Future<void> tambahWarga(Map<String, dynamic> data) async {
    try {
      await _supabase.from('warga').insert(data);
    } catch (e) {
      throw Exception('Gagal menambah warga: $e');
    }
  }

  // Tambah warga dengan account Supabase Auth
  Future<void> tambahWargaWithAccount({
    required Map<String, dynamic> wargaData,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create auth user
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'nik': wargaData['nik'],
          'nama_lengkap': wargaData['nama_lengkap'],
          'role': wargaData['role'] ?? 'warga',
        },
      );

      if (authResponse.user == null) {
        throw Exception('Gagal membuat akun auth');
      }

      // 2. Update warga data dengan user_id
      wargaData['user_id'] = authResponse.user!.id;
      wargaData['email'] = email;

      // 3. Insert ke tabel warga
      await _supabase.from('warga').upsert(wargaData);
    } catch (e) {
      throw Exception('Gagal menambah warga dengan akun: $e');
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
