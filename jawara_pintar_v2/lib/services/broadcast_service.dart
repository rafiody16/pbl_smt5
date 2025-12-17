import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/broadcast.dart';

class BroadcastService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Broadcast>> fetchBroadcast() async {
    final res = await _supabase
        .from('broadcast')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((e) => Broadcast.fromMap(e)).toList();
  }

  Future<Broadcast> createBroadcast(Broadcast b) async {
    final res = await _supabase
        .from('broadcast')
        .insert(b.toMap(includeId: false))
        .select()
        .single();
    return Broadcast.fromMap(res);
  }

  Future<Broadcast> updateBroadcast(int id, Broadcast b) async {
    final res = await _supabase
        .from('broadcast')
        .update(b.toMap(includeId: false))
        .eq('id', id)
        .select()
        .single();
    return Broadcast.fromMap(res);
  }

  Future<void> deleteBroadcast(int id) async {
    await _supabase.from('broadcast').delete().eq('id', id);
  }
}
