class KeluargaModel {
  final int? id;
  final String namaKeluarga;
  final String? kepalaKeluarga;
  final int? rumahId; // Foreign Key ke tabel rumah
  final String status; // 'Aktif', 'Pindah', dll
  final int? jumlahAnggota;
  final DateTime? createdAt;

  KeluargaModel({
    this.id,
    required this.namaKeluarga,
    this.kepalaKeluarga,
    this.rumahId,
    this.status = 'Aktif',
    this.jumlahAnggota,
    this.createdAt,
  });

  factory KeluargaModel.fromMap(Map<String, dynamic> map) {
    return KeluargaModel(
      id: map['id'],
      namaKeluarga: map['nama_keluarga'] ?? '',
      kepalaKeluarga: map['kepala_keluarga'],
      rumahId: map['rumah_id'],
      status: map['status'] ?? 'Aktif',
      jumlahAnggota: map['jumlah_anggota'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // ID tidak disertakan agar tidak error 23502 saat insert/update
      'nama_keluarga': namaKeluarga,
      'kepala_keluarga': kepalaKeluarga,
      'rumah_id': rumahId,
      'status': status,
      'jumlah_anggota': jumlahAnggota,
    };
  }
}
