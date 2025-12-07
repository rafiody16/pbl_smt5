// lib/providers/keuangan_provider.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/keuangan_models.dart';

class KeuanganProvider with ChangeNotifier {
  // Instance Supabase Client
  final _supabase = Supabase.instance.client;

  // State Data
  List<PemasukanModel> _listPemasukan = [];
  List<PengeluaranModel> _listPengeluaran = [];
  List<KategoriModel> _listKategori = [];

  bool _isLoading = false;

  // Getters (Untuk diakses UI)
  List<PemasukanModel> get listPemasukan => _listPemasukan;
  List<PengeluaranModel> get listPengeluaran => _listPengeluaran;
  List<KategoriModel> get listKategori => _listKategori;
  bool get isLoading => _isLoading;

  // Getter Hitung Saldo Otomatis (Masuk - Keluar)
  double get totalSaldo {
    double totalMasuk = _listPemasukan.fold(
      0,
      (sum, item) => sum + item.nominal,
    );
    double totalKeluar = _listPengeluaran.fold(
      0,
      (sum, item) => sum + item.nominal,
    );
    return totalMasuk - totalKeluar;
  }

  // === 1. INITIALIZE DATA (Panggil ini saat aplikasi/halaman dibuka) ===
  Future<void> initData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // A. Ambil Data Kategori
      final resKategori = await _supabase.from('kategori_keuangan').select();
      _listKategori = (resKategori as List)
          .map((e) => KategoriModel.fromJson(e))
          .toList();

      // B. Ambil Data Pemasukan (Urut tanggal terbaru)
      final resMasuk = await _supabase
          .from('pemasukan')
          .select()
          .order('tanggal_transaksi', ascending: false);
      _listPemasukan = (resMasuk as List)
          .map((e) => PemasukanModel.fromJson(e))
          .toList();

      // C. Ambil Data Pengeluaran (Urut tanggal terbaru)
      final resKeluar = await _supabase
          .from('pengeluaran')
          .select()
          .order('tanggal_transaksi', ascending: false);
      _listPengeluaran = (resKeluar as List)
          .map((e) => PengeluaranModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ Error load keuangan: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Kabari UI bahwa data sudah siap
    }
  }

  // === 2. CREATE PEMASUKAN ===
  Future<bool> tambahPemasukan(PemasukanModel data) async {
    try {
      final dataMap = data.toJson();
      await _supabase.from('pemasukan').insert(dataMap);

      // Refresh data agar list di UI langsung update
      await initData();
      return true;
    } catch (e) {
      debugPrint("❌ Gagal tambah pemasukan: $e");
      return false;
    }
  }

  // === 3. CREATE PENGELUARAN ===
  Future<bool> tambahPengeluaran(PengeluaranModel data) async {
    try {
      final dataMap = data.toJson();
      await _supabase.from('pengeluaran').insert(dataMap);

      await initData();
      return true;
    } catch (e) {
      debugPrint("❌ Gagal tambah pengeluaran: $e");
      return false;
    }
  }

  Future<bool> tambahKategori(String nama, double nominal) async {
    try {
      await _supabase.from('kategori_keuangan').insert({
        'nama_kategori': nama,
        'jenis': 'Pemasukan', // Default jenis
        'tipe_iuran': 'rutin', // Penanda ini adalah iuran
        'nominal_default': nominal,
      });
      await initData(); // Refresh data
      return true;
    } catch (e) {
      debugPrint("Gagal tambah kategori: $e");
      return false;
    }
  }

  // === 4. HELPER: Ambil Nama Kategori by ID ===
  // Berguna untuk menampilkan nama kategori di List (bukan ID-nya)
  String getNamaKategori(int id) {
    final kategori = _listKategori.firstWhere(
      (e) => e.id == id,
      orElse: () => KategoriModel(id: 0, namaKategori: 'Lainnya', jenis: '-'),
    );
    return kategori.namaKategori;
  }
}
