import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/rumah.dart';

class RumahBloc {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Stream Controller untuk List Rumah
  // Kita gunakan .stream() dari Supabase agar REALTIME
  Stream<List<Rumah>> get rumahStream {
    return _supabase
        .from('rumah')
        .stream(primaryKey: ['id'])
        .order('alamat', ascending: true)
        .map((data) => data.map((e) => Rumah.fromMap(e)).toList());
  }

  // 2. CRUD Operations

  // Tambah Rumah
  Future<void> addRumah(Rumah rumah) async {
    try {
      await _supabase.from('rumah').insert(rumah.toMap());
    } catch (e) {
      throw Exception('Gagal menambah rumah: $e');
    }
  }

  // Update Rumah
  Future<void> updateRumah(int id, Rumah rumah) async {
    try {
      // Hapus created_at jika ada di map (untuk update aman)
      await _supabase.from('rumah').update(rumah.toMap()).eq('id', id);
    } catch (e) {
      throw Exception('Gagal update rumah: $e');
    }
  }

  // Hapus Rumah
  Future<void> deleteRumah(int id) async {
    try {
      await _supabase.from('rumah').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus rumah: $e');
    }
  }

  // Dispose (Tidak terlalu butuh dispose untuk Supabase stream dasar,
  // tapi good practice jika pakai Controller manual)
  void dispose() {}
}
