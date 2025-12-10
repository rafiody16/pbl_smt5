import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/keluarga_model.dart';

class KeluargaBloc {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Stream Utama Data Keluarga
  Stream<List<KeluargaModel>> get keluargaStream {
    return _supabase
        .from('keluarga')
        .stream(primaryKey: ['id'])
        .order('nama_keluarga', ascending: true)
        .map((data) => data.map((e) => KeluargaModel.fromMap(e)).toList());
  }

  // 2. Helper: Ambil Data Rumah untuk Dropdown (Future, bukan Stream)
  Future<List<Map<String, dynamic>>> getDaftarRumah() async {
    try {
      final response = await _supabase
          .from('rumah')
          .select('id, alamat, rt, rw')
          .order('alamat');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  // 3. Helper: Ambil Nama Rumah berdasarkan ID (Untuk display di Detail/List)
  Future<String> getNamaRumah(int? rumahId) async {
    if (rumahId == null) return '-';
    try {
      final response = await _supabase
          .from('rumah')
          .select('alamat')
          .eq('id', rumahId)
          .single();
      return response['alamat'] as String;
    } catch (e) {
      return 'Rumah tidak ditemukan';
    }
  }

  // 4. CRUD Operations

  Future<void> addKeluarga(KeluargaModel keluarga) async {
    try {
      await _supabase.from('keluarga').insert(keluarga.toMap());
    } catch (e) {
      throw Exception('Gagal menambah keluarga: $e');
    }
  }

  Future<void> updateKeluarga(int id, KeluargaModel keluarga) async {
    try {
      await _supabase.from('keluarga').update(keluarga.toMap()).eq('id', id);
    } catch (e) {
      throw Exception('Gagal update keluarga: $e');
    }
  }

  Future<void> deleteKeluarga(int id) async {
    try {
      await _supabase.from('keluarga').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus keluarga: $e');
    }
  }

  void dispose() {}
}
