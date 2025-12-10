class Produk {
  final int? id;
  final String sellerNik;
  final String? sellerName; // Field tambahan dari join tabel warga
  final String namaProduk;
  final String? deskripsi;
  final int harga; // Menggunakan int/BigInt sesuai format database
  final int stok;
  final String kategori;
  final String? gambarUrl;
  final bool isActive;
  final DateTime createdAt;

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
    required this.createdAt,
  });

  factory Produk.fromMap(Map<String, dynamic> map) {
    return Produk(
      id: map['id'],
      sellerNik: map['seller_nik'],
      // Mengambil nama seller jika di-join dengan tabel warga
      sellerName: map['warga'] != null ? map['warga']['nama_lengkap'] : null,
      namaProduk: map['nama_produk'],
      deskripsi: map['deskripsi'],
      harga: map['harga'] is String ? int.parse(map['harga']) : map['harga'],
      stok: map['stok'],
      kategori: map['kategori'] ?? 'Lainnya',
      gambarUrl: map['gambar_url'],
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id' biasanya auto-increment, tidak perlu dikirim saat insert
      'seller_nik': sellerNik,
      'nama_produk': namaProduk,
      'deskripsi': deskripsi,
      'harga': harga,
      'stok': stok,
      'kategori': kategori,
      'gambar_url': gambarUrl,
      'is_active': isActive,
      // 'created_at': di-handle database default value
    };
  }
}
