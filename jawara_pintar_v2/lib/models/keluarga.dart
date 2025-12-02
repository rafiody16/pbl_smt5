class Keluarga {
  final int id;
  final String namaKeluarga;
  final String? kepalaKeluarga;
  final int? rumahId;
  final String status; // default 'Aktif'
  final int? jumlahAnggota;
  final DateTime createdAt;

  Keluarga({
    required this.id,
    required this.namaKeluarga,
    this.kepalaKeluarga,
    this.rumahId,
    required this.status,
    this.jumlahAnggota,
    required this.createdAt,
  });

  factory Keluarga.fromMap(Map<String, dynamic> map) {
    return Keluarga(
      id: map['id'],
      namaKeluarga: map['nama_keluarga'] as String,
      kepalaKeluarga: map['kepala_keluarga'] as String?,
      rumahId: map['rumah_id'],
      status: map['status'] ?? 'Aktif',
      jumlahAnggota: map['jumlah_anggota'] as int?,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_keluarga': namaKeluarga,
      'kepala_keluarga': kepalaKeluarga,
      'rumah_id': rumahId,
      'status': status,
      'jumlah_anggota': jumlahAnggota,
    };
  }
}
