import 'package:flutter/foundation.dart';
import '../models/warga.dart';
import '../models/keluarga.dart';
import '../services/warga_service.dart';
import '../services/keluarga_service.dart';

class WargaProvider with ChangeNotifier {
  final WargaService _wargaService = WargaService();
  final KeluargaService _keluargaService = KeluargaService();

  // State
  List<Warga> _wargaList = [];
  List<Keluarga> _keluargaList = [];
  Map<String, String> _filters = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Warga> get wargaList => _wargaList;
  List<Keluarga> get keluargaList => _keluargaList;
  Map<String, String> get filters => _filters;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtered warga list based on active filters
  List<Warga> get filteredWargaList {
    if (_filters.isEmpty) return _wargaList;

    return _wargaList.where((warga) {
      // Filter by nama
      if (_filters.containsKey('nama') && _filters['nama']!.isNotEmpty) {
        if (!warga.namaLengkap.toLowerCase().contains(
          _filters['nama']!.toLowerCase(),
        )) {
          return false;
        }
      }

      // Filter by NIK
      if (_filters.containsKey('nik') && _filters['nik']!.isNotEmpty) {
        if (!warga.nik.contains(_filters['nik']!)) {
          return false;
        }
      }

      // Filter by jenis kelamin
      if (_filters.containsKey('jenisKelamin') &&
          _filters['jenisKelamin']!.isNotEmpty) {
        if (warga.jenisKelamin != _filters['jenisKelamin']) {
          return false;
        }
      }

      // Filter by agama
      if (_filters.containsKey('agama') && _filters['agama']!.isNotEmpty) {
        if (warga.agama != _filters['agama']) {
          return false;
        }
      }

      // Filter by status domisili
      if (_filters.containsKey('statusDomisili') &&
          _filters['statusDomisili']!.isNotEmpty) {
        if (warga.statusDomisili != _filters['statusDomisili']) {
          return false;
        }
      }

      // Filter by pekerjaan
      if (_filters.containsKey('pekerjaan') &&
          _filters['pekerjaan']!.isNotEmpty) {
        if (warga.pekerjaan != _filters['pekerjaan']) {
          return false;
        }
      }

      // Filter by keluarga
      if (_filters.containsKey('keluarga') &&
          _filters['keluarga']!.isNotEmpty) {
        final keluargaId = int.tryParse(_filters['keluarga']!);
        if (warga.keluargaId != keluargaId) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Load all warga from database
  Future<void> loadWarga() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _wargaService.getWarga();
      _wargaList = data.map((map) => Warga.fromMap(map)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load keluarga data
  Future<void> loadKeluarga() async {
    try {
      final data = await _keluargaService.getKeluarga();
      _keluargaList = data.map((map) => Keluarga.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Get keluarga name by ID
  String getKeluargaName(int? keluargaId) {
    if (keluargaId == null) return 'Belum ada keluarga';

    try {
      final keluarga = _keluargaList.firstWhere(
        (k) => k.id == keluargaId,
        orElse: () => Keluarga(
          id: 0,
          namaKeluarga: 'Tidak ditemukan',
          status: 'Aktif',
          createdAt: DateTime.now(),
        ),
      );
      return keluarga.namaKeluarga;
    } catch (e) {
      return 'Tidak ditemukan';
    }
  }

  // Add new warga
  Future<bool> tambahWarga(Warga warga) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _wargaService.tambahWarga(warga.toMap());
      await loadWarga(); // Reload to get fresh data
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update existing warga
  Future<bool> updateWarga(String nik, Warga warga) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _wargaService.updateWarga(nik, warga.toMap());
      await loadWarga();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete warga
  Future<bool> deleteWarga(String nik) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _wargaService.deleteWarga(nik);
      await loadWarga();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Search warga
  Future<void> searchWarga(String query) async {
    if (query.isEmpty) {
      await loadWarga();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _wargaService.searchWarga(query);
      _wargaList = data.map((map) => Warga.fromMap(map)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Apply filters
  void applyFilters(Map<String, String> newFilters) {
    _filters = Map.from(newFilters);
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _filters.clear();
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
