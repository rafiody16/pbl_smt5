import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/broadcast.dart';
import '../services/broadcast_service.dart';

class BroadcastProvider with ChangeNotifier {
  final BroadcastService _service = BroadcastService();
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Broadcast> _items = [];
  bool _loading = false;
  String? _error;
  RealtimeChannel? _rtSub;

  List<Broadcast> get items => _items;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> init() async {
    await fetch();
    _subscribeRealtime();
  }

  Future<void> fetch() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _service.fetchBroadcast();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> add(Broadcast b) async {
    _loading = true;
    notifyListeners();
    try {
      final created = await _service.createBroadcast(b);
      _items.insert(0, created);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> update(int id, Broadcast b) async {
    _loading = true;
    notifyListeners();
    try {
      final updated = await _service.updateBroadcast(id, b);
      final idx = _items.indexWhere((x) => x.id == id);
      if (idx != -1) _items[idx] = updated;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> remove(int id) async {
    _loading = true;
    notifyListeners();
    try {
      await _service.deleteBroadcast(id);
      _items.removeWhere((x) => x.id == id);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  void _subscribeRealtime() {
    _rtSub?.unsubscribe();
    _rtSub = _supabase.channel('public:broadcast');
    _rtSub!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'broadcast',
          callback: (payload) async {
            await fetch();
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _rtSub?.unsubscribe();
    super.dispose();
  }
}
