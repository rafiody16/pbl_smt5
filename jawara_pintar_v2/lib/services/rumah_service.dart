import 'package:supabase_flutter/supabase_flutter.dart';

class RumahService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil semua data rumah
  Future<List<Map<String, dynamic>>> getRumah() async {
    try {
      final response = await _supabase.from('rumah').select().order('alamat');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mengambil data rumah: $e');
    }
  }

  // Mengambil rumah berdasarkan ID
  Future<Map<String, dynamic>> getRumahById(int id) async {
    try {
      final response = await _supabase
          .from('rumah')
          .select()
          .eq('id', id)
          .single();

      return response;
    } catch (e) {
      throw Exception('Gagal mengambil data rumah: $e');
    }
  }

  // Menambah rumah baru
  Future<void> tambahRumah(Map<String, dynamic> data) async {
    try {
      await _supabase.from('rumah').insert(data);
    } catch (e) {
      throw Exception('Gagal menambah rumah: $e');
    }
  }

  // Update rumah
  Future<void> updateRumah(int id, Map<String, dynamic> data) async {
    try {
      await _supabase.from('rumah').update(data).eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengupdate rumah: $e');
    }
  }

  // Hapus rumah
  Future<void> deleteRumah(int id) async {
    try {
      await _supabase.from('rumah').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus rumah: $e');
    }
  }
}
