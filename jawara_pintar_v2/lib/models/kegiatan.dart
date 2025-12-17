class Kegiatan {
  final int? id;
  final String namaKegiatan;
  final String? kategori;
  final String? deskripsi;
  final String? lokasi;
  final DateTime? tanggalPelaksanaan;
  final String? penanggungJawab;
  final String? dibuatOleh; // warga.nik
  final String? posterUrl;
  final DateTime? createdAt;

  Kegiatan({
    this.id,
    required this.namaKegiatan,
    this.kategori,
    this.deskripsi,
    this.lokasi,
    this.tanggalPelaksanaan,
    this.penanggungJawab,
    this.dibuatOleh,
    this.posterUrl,
    this.createdAt,
  });

  factory Kegiatan.fromMap(Map<String, dynamic> map) {
    return Kegiatan(
      id: map['id'],
      namaKegiatan: map['nama_kegiatan'],
      kategori: map['kategori'],
      deskripsi: map['deskripsi'],
      lokasi: map['lokasi'],
      tanggalPelaksanaan: map['tanggal_pelaksanaan'] != null
          ? DateTime.parse(map['tanggal_pelaksanaan'])
          : null,
      penanggungJawab: map['penanggung_jawab'],
      dibuatOleh: map['dibuat_oleh'],
      posterUrl: map['poster_url'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = <String, dynamic>{
      'nama_kegiatan': namaKegiatan,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'tanggal_pelaksanaan': tanggalPelaksanaan?.toIso8601String(),
      'penanggung_jawab': penanggungJawab,
      'dibuat_oleh': dibuatOleh,
      'poster_url': posterUrl,
    };

    // Hanya kirim kolom id jika diminta dan tidak null
    if (includeId && id != null) {
      map['id'] = id;
    }

    return map;
  }
}
