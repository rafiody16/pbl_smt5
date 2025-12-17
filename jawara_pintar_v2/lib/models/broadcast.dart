class Broadcast {
  final int? id;
  final String judul;
  final String? isiPesan;
  final DateTime? tanggalPublikasi;
  final String? dibuatOleh;
  final String? lampiranGambar;
  final String? lampiranDokumen;
  final DateTime? createdAt;

  Broadcast({
    this.id,
    required this.judul,
    this.isiPesan,
    this.tanggalPublikasi,
    this.dibuatOleh,
    this.lampiranGambar,
    this.lampiranDokumen,
    this.createdAt,
  });

  factory Broadcast.fromMap(Map<String, dynamic> map) {
    return Broadcast(
      id: map['id'],
      judul: map['judul'],
      isiPesan: map['isi_pesan'],
      tanggalPublikasi: map['tanggal_publikasi'] != null
          ? DateTime.parse(map['tanggal_publikasi'].toString())
          : null,
      dibuatOleh: map['dibuat_oleh'],
      lampiranGambar: map['lampiran_gambar'],
      lampiranDokumen: map['lampiran_dokumen'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = <String, dynamic>{
      'judul': judul,
      'isi_pesan': isiPesan,
      'tanggal_publikasi': tanggalPublikasi?.toIso8601String(),
      'dibuat_oleh': dibuatOleh,
      'lampiran_gambar': lampiranGambar,
      'lampiran_dokumen': lampiranDokumen,
    };
    if (includeId && id != null) map['id'] = id;
    return map;
  }
}
