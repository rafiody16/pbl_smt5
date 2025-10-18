class RumahData {
  static final List<String> statusRumahList = ['Tersedia', 'Ditempati'];

  static final List<Map<String, dynamic>> semuaDataRumah = [
    {
      'no': 1,
      'alamat': 'Jl. Merbabu',
      'status': 'Tersedia',
    },
    {
      'no': 2,
      'alamat': 'Malang',
      'status': 'Ditempati',
    },
    {
      'no': 3,
      'alamat': 'Griyashanta L203',
      'status': 'Tersedia',
    },
    {
      'no': 4,
      'alamat': 'wenwer',
      'status': 'Ditempati',
    },
    {
      'no': 5,
      'alamat': 'Jl. Baru bangun',
      'status': 'Tersedia',
    },
    {
      'no': 6,
      'alamat': 'fasda',
      'status': 'Ditempati',
    },
    {
      'no': 7,
      'alamat': 'Bogor Raya Permai FJ 2 no 11',
      'status': 'Ditempati',
    },
    {
      'no': 8,
      'alamat': 'malang',
      'status': 'Ditempati',
    },
    {
      'no': 9,
      'alamat': 'Quis consequatur nob',
      'status': 'Tersedia',
    },
    {
      'no': 10,
      'alamat': 'i',
      'status': 'Tersedia',
    },
  ];

  static Map<String, dynamic>? getRumahByNo(int no) {
    try {
      return semuaDataRumah.firstWhere((rumah) => rumah['no'] == no);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getRumahByAlamat(String alamat) {
    try {
      return semuaDataRumah.firstWhere((rumah) => rumah['alamat'] == alamat);
    } catch (e) {
      return null;
    }
  }
}