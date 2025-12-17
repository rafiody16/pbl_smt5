import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kegiatan.dart';

class KegiatanService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Kegiatan>> fetchKegiatan() async {
    final res = await _supabase
        .from('kegiatan')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((e) => Kegiatan.fromMap(e)).toList();
  }

  Future<Kegiatan> createKegiatan(Kegiatan kegiatan) async {
    final res = await _supabase
        .from('kegiatan')
        // Jangan kirim kolom id agar Postgres memakai default/identity
        .insert(kegiatan.toMap(includeId: false))
        .select()
        .single();
    return Kegiatan.fromMap(res);
  }

  Future<Kegiatan> updateKegiatan(int id, Kegiatan kegiatan) async {
    final res = await _supabase
        .from('kegiatan')
        // id dipakai di filter eq, tidak perlu dikirim di body
        .update(kegiatan.toMap(includeId: false))
        .eq('id', id)
        .select()
        .single();
    return Kegiatan.fromMap(res);
  }

  Future<void> deleteKegiatan(int id) async {
    await _supabase.from('kegiatan').delete().eq('id', id);
  }
}
