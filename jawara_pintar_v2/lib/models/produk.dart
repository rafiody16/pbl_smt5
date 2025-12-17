class Produk {
  final int? id;
  final String sellerNik;
  final String? sellerName;
  final String namaProduk;
  final String? deskripsi;

  // Gunakan double agar aman jika database mengirim desimal (numeric)
  final double harga;
  final int stok;

  final String kategori;
  final String? gambarUrl;
  final bool isActive;
  final DateTime? createdAt;

  Produk({
    this.id,
    required this.sellerNik,
    this.sellerName,
    required this.namaProduk,
    this.deskripsi,
    required this.harga,
    required this.stok,
    required this.kategori,
    this.gambarUrl,
    this.isActive = true,
    this.createdAt,
  });

  factory Produk.fromMap(Map<String, dynamic> map) {
    return Produk(
      id: map['id'],
      sellerNik: map['seller_nik'] ?? '',
      sellerName: (map['warga'] != null && map['warga'] is Map)
          ? map['warga']['nama_lengkap']
          : null,
      namaProduk: map['nama_produk'] ?? 'Tanpa Nama',
      deskripsi: map['deskripsi'] ?? '',

      // --- PERBAIKAN UTAMA DI SINI (Anti Error Null/Int/String) ---
      // Apapun tipenya (String, Int, Null), paksa jadi Double. Jika gagal, jadi 0.0
      harga: num.tryParse(map['harga']?.toString() ?? '0')?.toDouble() ?? 0.0,

      // Apapun tipenya, paksa jadi Int. Jika gagal, jadi 0
      stok: int.tryParse(map['stok']?.toString() ?? '0') ?? 0,

      // -------------------------------------------------------------
      kategori: map['kategori'] ?? 'Lainnya',
      gambarUrl: map['gambar_url'],
      isActive: map['is_active'] ?? true,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seller_nik': sellerNik,
      'nama_produk': namaProduk,
      'deskripsi': deskripsi,
      'harga': harga,
      'stok': stok,
      'kategori': kategori,
      'gambar_url': gambarUrl,
      'is_active': isActive,
    };
  }
}
