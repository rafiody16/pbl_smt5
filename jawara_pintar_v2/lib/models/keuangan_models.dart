// lib/models/keuangan_models.dart

// === 1. Model Kategori ===
class KategoriModel {
  final int id;
  final String namaKategori;
  final String jenis;
  final double nominalDefault; // Tambahan baru

  KategoriModel({
    required this.id,
    required this.namaKategori,
    required this.jenis,
    this.nominalDefault = 0,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'],
      namaKategori: json['nama_kategori'] ?? 'Tanpa Nama',
      jenis: json['jenis'] ?? '-',
      // Pastikan di database kolomnya 'nominal_default'
      nominalDefault: (json['nominal_default'] as num?)?.toDouble() ?? 0,
    );
  }
}

// === 2. Model Pemasukan ===
class PemasukanModel {
  final int? id; // Nullable karena saat create ID belum ada
  final String judul;
  final int kategoriId;
  final double nominal;
  final DateTime tanggalTransaksi;
  final String? statusBayar;
  final String? metodePembayaran;
  final String? buktiFoto;

  PemasukanModel({
    this.id,
    required this.judul,
    required this.kategoriId,
    required this.nominal,
    required this.tanggalTransaksi,
    this.statusBayar,
    this.metodePembayaran,
    this.buktiFoto,
  });

  // Fetch dari Supabase
  factory PemasukanModel.fromJson(Map<String, dynamic> json) {
    return PemasukanModel(
      id: json['id'],
      judul: json['judul'] ?? '',
      kategoriId: json['kategori_id'] ?? 0,
      nominal: (json['nominal'] as num).toDouble(),
      tanggalTransaksi: DateTime.parse(json['tanggal_transaksi']),
      statusBayar: json['status_bayar'],
      metodePembayaran: json['metode_pembayaran'],
      buktiFoto: json['bukti_foto'],
    );
  }

  // Kirim ke Supabase
  Map<String, dynamic> toJson() {
    return {
      // id tidak dikirim (auto increment)
      'judul': judul,
      'kategori_id': kategoriId,
      'nominal': nominal,
      'tanggal_transaksi': tanggalTransaksi.toIso8601String(),
      'status_bayar': statusBayar ?? 'Lunas',
      'metode_pembayaran': metodePembayaran ?? 'Tunai',
      'bukti_foto': buktiFoto,
    };
  }
}

// === 3. Model Pengeluaran ===
class PengeluaranModel {
  final int? id;
  final String judul;
  final int kategoriId;
  final double nominal;
  final DateTime tanggalTransaksi;
  final String? deskripsi;
  final String? dikeluarkanOleh;
  final String? buktiFoto;

  PengeluaranModel({
    this.id,
    required this.judul,
    required this.kategoriId,
    required this.nominal,
    required this.tanggalTransaksi,
    this.deskripsi,
    this.dikeluarkanOleh,
    this.buktiFoto,
  });

  // Fetch dari Supabase
  factory PengeluaranModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranModel(
      id: json['id'],
      judul: json['judul'] ?? '',
      kategoriId: json['kategori_id'] ?? 0,
      nominal: (json['nominal'] as num).toDouble(),
      tanggalTransaksi: DateTime.parse(json['tanggal_transaksi']),
      deskripsi: json['deskripsi'],
      dikeluarkanOleh: json['dikeluarkan_oleh'],
      buktiFoto: json['bukti_foto'],
    );
  }

  // Kirim ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'kategori_id': kategoriId,
      'nominal': nominal,
      'tanggal_transaksi': tanggalTransaksi.toIso8601String(),
      'deskripsi': deskripsi,
      'dikeluarkan_oleh': dikeluarkanOleh,
      'bukti_foto': buktiFoto,
    };
  }


}
