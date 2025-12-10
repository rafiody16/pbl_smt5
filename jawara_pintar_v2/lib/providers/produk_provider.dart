import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/produk.dart';
import '../services/marketplace_service.dart';

class ProdukProvider with ChangeNotifier {
  final MarketplaceService _service = MarketplaceService();

  // State
  List<Produk> _produkList = [];
  List<Produk> _filteredProdukList = []; // Untuk filter kategori lokal
  bool _isLoading = false;
  String? _errorMessage;
  String _activeCategory = "Semua";

  // Getters
  List<Produk> get produkList =>
      _activeCategory == "Semua" ? _produkList : _filteredProdukList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get activeCategory => _activeCategory;

  // 1. Load Semua Produk
  Future<void> loadProduk() async {
    _setLoading(true);
    try {
      final data = await _service.getProduk();
      _produkList = data.map((map) => Produk.fromMap(map)).toList();
      _applyLocalFilter(); // Reset filter
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // 2. Tambah Produk
  Future<bool> tambahProduk(
    Map<String, dynamic> data, {
    File? imageFile,
  }) async {
    _setLoading(true);
    try {
      await _service.tambahProduk(data, imageFile);
      await loadProduk(); // Refresh list
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // 3. Update Produk
  Future<bool> updateProduk(
    int id,
    Map<String, dynamic> data, {
    File? imageFile,
  }) async {
    _setLoading(true);
    try {
      await _service.updateProduk(id, data, imageFile);
      await loadProduk();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // 4. Delete Produk
  Future<bool> deleteProduk(int id) async {
    _setLoading(true);
    try {
      await _service.deleteProduk(id);
      await loadProduk();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // 5. Search Text
  Future<void> searchProduk(String query) async {
    if (query.isEmpty) {
      await loadProduk();
      return;
    }
    _setLoading(true);
    try {
      final data = await _service.searchProduk(query);
      _produkList = data.map((map) => Produk.fromMap(map)).toList();
      _applyLocalFilter(); // Re-apply category filter if needed
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // 6. Search Image
  Future<void> searchProdukByImage(File image) async {
    _setLoading(true);
    try {
      // Memanggil service visual search
      final data = await _service.searchProdukByImage(image);

      if (data.isEmpty) {
        // Jika mock masih kosong, kita tidak ubah list, tapi beri notif (via UI handling)
        // Atau bisa reset ke semua produk
      } else {
        _produkList = data.map((map) => Produk.fromMap(map)).toList();
      }
    } catch (e) {
      _errorMessage = "Gagal memproses gambar: $e";
    } finally {
      _setLoading(false);
    }
  }

  // 7. Filter Kategori (Lokal)
  void filterByCategory(String category) {
    _activeCategory = category;
    _applyLocalFilter();
    notifyListeners();
  }

  void _applyLocalFilter() {
    if (_activeCategory == "Semua") {
      _filteredProdukList = _produkList;
    } else {
      _filteredProdukList = _produkList
          .where(
            (p) => p.kategori.toLowerCase() == _activeCategory.toLowerCase(),
          )
          .toList();
    }
  }

  void _setLoading(bool val) {
    _isLoading = val;
    if (val) _errorMessage = null;
    notifyListeners();
  }
}
