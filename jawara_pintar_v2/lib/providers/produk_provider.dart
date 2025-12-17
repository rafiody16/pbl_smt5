import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/produk.dart';
import '../services/marketplace_service.dart';

class ProdukProvider with ChangeNotifier {
  final MarketplaceService _service = MarketplaceService();

  List<Produk> _produkList = [];
  List<Produk> _filteredProdukList = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _activeCategory = "Semua";
  String? _lastDetectedKeyword;

  List<Produk> get produkList =>
      _activeCategory == "Semua" ? _produkList : _filteredProdukList;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get activeCategory => _activeCategory;
  String? get lastDetectedKeyword => _lastDetectedKeyword;

  Future<void> loadProduk() async {
    _setLoading(true);
    try {
      final data = await _service.getProduk();
      _produkList = data.map((e) => Produk.fromMap(e)).toList();
      _lastDetectedKeyword = null;
      _applyLocalFilter();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> tambahProduk(
    Map<String, dynamic> data, {
    File? imageFile,
  }) async {
    _setLoading(true);
    try {
      await _service.tambahProduk(data, imageFile);
      await loadProduk();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

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

  Future<void> searchProduk(String query) async {
    if (query.trim().isEmpty) {
      await loadProduk();
      return;
    }

    _setLoading(true);
    try {
      final data = await _service.searchProduk(query);
      _produkList = data.map((e) => Produk.fromMap(e)).toList();
      _applyLocalFilter();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchProdukByImage(File image) async {
    _setLoading(true);
    try {
      final keyword = await _service.searchProdukByImage(image);

      if (keyword == null || keyword.isEmpty) {
        _errorMessage = "Motif batik tidak dapat dikenali";
        return;
      }

      _lastDetectedKeyword = keyword;

      final data = await _service.searchProduk(keyword);

      _produkList = data.map((e) => Produk.fromMap(e)).toList();
      _applyLocalFilter();
    } catch (e) {
      _errorMessage = "Gagal memproses gambar: $e";
    } finally {
      _setLoading(false);
    }
  }

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
