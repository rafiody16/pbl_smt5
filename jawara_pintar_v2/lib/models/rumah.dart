class Rumah {
  final int? id;
  final String alamat;
  final String rt;
  final String rw;
  final int? jumlahPenghuni;
  final String statusRumah; // 'Tersedia', 'Ditempati'
  final String? statusKepemilikan; // 'Milik Sendiri', 'Sewa', 'Dinas'
  final int? luasTanah;
  final int? luasBangunan;

  Rumah({
    this.id,
    required this.alamat,
    this.rt = '001',
    this.rw = '001',
    this.jumlahPenghuni,
    this.statusRumah = 'Tersedia',
    this.statusKepemilikan,
    this.luasTanah,
    this.luasBangunan,
  });

  factory Rumah.fromMap(Map<String, dynamic> map) {
    return Rumah(
      id: map['id'],
      alamat: map['alamat'] ?? '',
      rt: map['rt'] ?? '001',
      rw: map['rw'] ?? '001',
      jumlahPenghuni: map['jumlah_penghuni'],
      statusRumah: map['status_rumah'] ?? 'Tersedia',
      statusKepemilikan: map['status_kepemilikan'],
      luasTanah: map['luas_tanah'],
      luasBangunan: map['luas_bangunan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
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

// class Rumah {
//   final int? id;
//   final String alamat;
//   final String rt;
//   final String rw;
//   final int? jumlahPenghuni;
//   final String statusRumah;
//   final String? statusKepemilikan;
//   final int? luasTanah;
//   final int? luasBangunan;

//   Rumah({
//     this.id,
//     required this.alamat,
//     required this.rt,
//     required this.rw,
//     this.jumlahPenghuni,
//     this.statusRumah = 'Tersedia',
//     this.statusKepemilikan,
//     this.luasTanah,
//     this.luasBangunan,
//   });

//   factory Rumah.fromMap(Map<String, dynamic> map) {
//     return Rumah(
//       id: map['id'],
//       alamat: map['alamat'] as String,
//       rt: map['rt'] as String,
//       rw: map['rw'] as String,
//       jumlahPenghuni: map['jumlah_penghuni'] as int?,
//       statusRumah: map['status_rumah'] as String,
//       statusKepemilikan: map['status_kepemilikan'] as String,
//       luasTanah: map['luas_tanah'] as int?,
//       luasBangunan: map['luas_bangunan'] as int?,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'alamat': alamat,
//       'rt': rt,
//       'rw': rw,
//       'jumlah_penghuni': jumlahPenghuni,
//       'status_rumah': statusRumah,
//       'status_kepemilikan': statusKepemilikan,
//       'luas_tanah': luasTanah,
//       'luas_bangunan': luasBangunan,
//     };
//   }
// }
