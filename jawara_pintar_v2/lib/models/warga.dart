class Warga {
  final String nik;
  final String? userId;
  final int? keluargaId;
  final String namaLengkap;
  final String? email;
  final String? noTelepon;
  final String? jenisKelamin;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? agama;
  final String? golonganDarah;
  final String? pendidikanTerakhir;
  final String? pekerjaan;
  final String? peran;
  final String statusDomisili;
  final String statusHidup;
  final String? fotoUrl;
  final String role; // admin / bendahara / warga / ...
  final DateTime createdAt;

  Warga({
    required this.nik,
    this.userId,
    this.keluargaId,
    required this.namaLengkap,
    this.email,
    this.noTelepon,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.agama,
    this.golonganDarah,
    this.pendidikanTerakhir,
    this.pekerjaan,
    this.peran,
    this.statusDomisili = 'Tetap',
    this.statusHidup = 'Hidup',
    this.fotoUrl,
    this.role = 'warga',
    required this.createdAt,
  });

  factory Warga.fromMap(Map<String, dynamic> map) {
    return Warga(
      nik: map['nik'],
      userId: map['user_id'],
      keluargaId: map['keluarga_id'],
      namaLengkap: map['nama_lengkap'],
      email: map['email'],
      noTelepon: map['no_telepon'],
      jenisKelamin: map['jenis_kelamin'],
      tempatLahir: map['tempat_lahir'],
      tanggalLahir: map['tanggal_lahir'] != null
          ? DateTime.parse(map['tanggal_lahir'])
          : null,
      agama: map['agama'],
      golonganDarah: map['golongan_darah'],
      pendidikanTerakhir: map['pendidikan_terakhir'],
      pekerjaan: map['pekerjaan'],
      peran: map['peran'],
      statusDomisili: map['status_domisili'] ?? 'Tetap',
      statusHidup: map['status_hidup'] ?? 'Hidup',
      fotoUrl: map['foto_url'],
      role: map['role'] ?? 'warga',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nik': nik,
      'user_id': userId,
      'keluarga_id': keluargaId,
      'nama_lengkap': namaLengkap,
      'email': email,
      'no_telepon': noTelepon,
      'jenis_kelamin': jenisKelamin,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'agama': agama,
      'golongan_darah': golonganDarah,
      'pendidikan_terakhir': pendidikanTerakhir,
      'pekerjaan': pekerjaan,
      'peran': peran,
      'status_domisili': statusDomisili,
      'status_hidup': statusHidup,
      'foto_url': fotoUrl,
      'role': role,
    };
  }
}
