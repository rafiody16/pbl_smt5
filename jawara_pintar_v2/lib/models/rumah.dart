class Rumah {
  final int id;
  final String alamat;
  final String rt;
  final String rw;
  final int? jumlahPenghuni;
  final String statusRumah;
  final String statusKepemilikan;
  final int? luasTanah;
  final int? luasBangunan;
  final DateTime createdAt;

  Rumah({
    required this.id,
    required this.alamat,
    required this.rt,
    required this.rw,
    this.jumlahPenghuni,
    required this.statusRumah,
    required this.statusKepemilikan,
    this.luasTanah,
    this.luasBangunan,
    required this.createdAt,
  });

  factory Rumah.fromMap(Map<String, dynamic> map) {
    return Rumah(
      id: map['id'],
      alamat: map['alamat'] as String,
      rt: map['rt'] as String,
      rw: map['rw'] as String,
      jumlahPenghuni: map['jumlah_penghuni'] as int?,
      statusRumah: map['status_rumah'] as String,
      statusKepemilikan: map['status_kepemilikan'] as String,
      luasTanah: map['luas_tanah'] as int?,
      luasBangunan: map['luas_bangunan'] as int?,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alamat': alamat,
      'rt': rt,
      'rw': rw,
      'jumlah_penghuni': jumlahPenghuni,
      'status_rumah': statusRumah,
      'status_kepemilikan': statusKepemilikan,
      'luas_tanah': luasTanah,
      'luas_bangunan': luasBangunan,
    };
  }
}
