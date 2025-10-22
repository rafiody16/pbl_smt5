class LogData {
  static final List<Map<String, String>> dataLog = [
    {
      'deskripsi':
          'Menugaskan tagihan : Bersih Desa periode Oktober 2025 sebesar Rp. 200.000',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi': 'Membuat broadcast baru: Pengumuman',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi':
          'Menugaskan tagihan : Bersih Desa periode Oktober 2025 sebesar Rp. 200.000',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi': 'Mendownload laporan keuangan',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi': 'Menambahkan iuran baru: asad',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi':
          'Menugaskan tagihan : Mingguan periode Oktober 2025 sebesar Rp. 12',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi':
          'Menugaskan tagihan : Mingguan periode Oktober 2025 sebesar Rp. 12',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi':
          'Menugaskan tagihan : Mingguan periode Oktober 2025 sebesar Rp. 12',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi': 'Menambahkan iuran baru: yyy',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi':
          'Menugaskan tagihan : Mingguan periode Oktober 2025 sebesar Rp. 12',
      'aktor': 'Admin Jawara',
      'tanggal': '21 Oktober 2025',
    },
    {
      'deskripsi': 'Menghapus data iuran tidak valid',
      'aktor': 'Admin Jawara',
      'tanggal': '22 Oktober 2025',
    },
    {
      'deskripsi': 'Menambahkan user baru: Bendahara',
      'aktor': 'Admin Jawara',
      'tanggal': '22 Oktober 2025',
    },
    {
      'deskripsi': 'Membuat laporan rekap iuran bulanan',
      'aktor': 'Admin Jawara',
      'tanggal': '22 Oktober 2025',
    },
    {
      'deskripsi':
          'Menugaskan tagihan : Kebersihan Mingguan sebesar Rp. 15.000',
      'aktor': 'Admin Jawara',
      'tanggal': '22 Oktober 2025',
    },
    {
      'deskripsi': 'Mengupdate status tagihan menjadi lunas',
      'aktor': 'Admin Jawara',
      'tanggal': '22 Oktober 2025',
    },
  ];

  static List<Map<String, dynamic>> get semuaDataLog {
    List<Map<String, dynamic>> semuaLog = [];
    for (var log in dataLog) {
      semuaLog.add(Map<String, dynamic>.from(log));
    }
    return semuaLog;
  }

  static Map<String, dynamic>? getLogByAktor(String aktorLog) {
    try {
      return dataLog.firstWhere((log) => log['aktor'] == aktorLog);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic>? getLogByDeskripsi(String deskripsi) {
    try {
      return dataLog.firstWhere((log) => log['deskripsi'] == deskripsi);
    } catch (e) {
      return null;
    }
  }
}
