import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/kegiatan.dart';
import '../services/kegiatan_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KegiatanProvider with ChangeNotifier {
  final KegiatanService _service = KegiatanService();
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Kegiatan> _items = [];
  bool _loading = false;
  String? _error;
  Map<String, String> _filters = {};
  RealtimeChannel? _rtSub;

  List<Kegiatan> get items => _applyFilters(_items);
  bool get isLoading => _loading;
  String? get error => _error;
  Map<String, String> get filters => _filters;

  Future<void> init() async {
    await fetch();
    _subscribeRealtime();
  }

  Future<void> fetch() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _service.fetchKegiatan();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> add(Kegiatan kegiatan) async {
    _loading = true;
    notifyListeners();
    try {
      final created = await _service.createKegiatan(kegiatan);
      _items.insert(0, created);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> update(int id, Kegiatan kegiatan) async {
    _loading = true;
    notifyListeners();
    try {
      final updated = await _service.updateKegiatan(id, kegiatan);
      final idx = _items.indexWhere((k) => k.id == id);
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
      await _service.deleteKegiatan(id);
      _items.removeWhere((k) => k.id == id);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  void setFilters(Map<String, String> filters) {
    _filters = filters;
    notifyListeners();
  }

  void clearFilters() {
    _filters = {};
    notifyListeners();
  }

  List<Kegiatan> _applyFilters(List<Kegiatan> list) {
    return list.where((k) {
      if (_filters.containsKey('nama') && _filters['nama']!.isNotEmpty) {
        if (!k.namaKegiatan.toLowerCase().contains(
          _filters['nama']!.toLowerCase(),
        ))
          return false;
      }
      if (_filters.containsKey('kategori') &&
          _filters['kategori']!.isNotEmpty) {
        if ((k.kategori ?? '') != _filters['kategori']) return false;
      }
      if (_filters.containsKey('tanggal') && _filters['tanggal']!.isNotEmpty) {
        final filter = DateTime.tryParse(_filters['tanggal']!);
        if (filter != null && k.tanggalPelaksanaan != null) {
          if (k.tanggalPelaksanaan!.toIso8601String().substring(0, 10) !=
              filter.toIso8601String().substring(0, 10))
            return false;
        }
      }
      if (_filters.containsKey('penanggungJawab') &&
          _filters['penanggungJawab']!.isNotEmpty) {
        if ((k.penanggungJawab ?? '').toLowerCase().contains(
              _filters['penanggungJawab']!.toLowerCase(),
            ) ==
            false)
          return false;
      }
      return true;
    }).toList();
  }

  void _subscribeRealtime() {
    // Bersihkan channel lama jika ada
    _rtSub?.unsubscribe();

    // Inisialisasi channel baru
    _rtSub = _supabase.channel('public:kegiatan');

    // Setup listener
    _rtSub!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'kegiatan',
          callback: (payload) async {
            await fetch();
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    // UBAH CARA CANCEL/UNSUBSCRIBE
    _rtSub?.unsubscribe();
    super.dispose();
  }
}
