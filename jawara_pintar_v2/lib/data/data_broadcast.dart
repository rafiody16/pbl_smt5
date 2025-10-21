class BroadcastData {
  static final List<Map<String, dynamic>> dataBroadcast = [
    {
      "judul": "Kerja Bakti Bersama",
      "isi_pesan":
          "Seluruh warga diharapkan hadir untuk kegiatan kerja bakti membersihkan lingkungan.",
      "tanggal_publikasi": "10 Oktober 2025",
      "dibuat_oleh": "Admin Jawara",
      "lampiran_gambar": "a.jpg",
      "lampiran_dokumen": "a.pdf",
    },
    {
      "judul": "Rapat RT Bulanan",
      "isi_pesan":
          "Undangan untuk seluruh warga menghadiri rapat bulanan RT membahas keamanan dan kebersihan.",
      "tanggal_publikasi": "12 Oktober 2025",
      "dibuat_oleh": "Admin Jawara",
      "lampiran_gambar": "a.jpg",
      "lampiran_dokumen": "a.pdf",
    },
    {
      "judul": "Gotong Royong Perbaikan Jalan",
      "isi_pesan":
          "Mari bersama-sama memperbaiki jalan lingkungan yang rusak karena hujan deras.",
      "tanggal_publikasi": "14 Oktober 2025",
      "dibuat_oleh": "Admin Jawara",
      "lampiran_gambar": "a.jpg",
      "lampiran_dokumen": "a.pdf",
    },
    {
      "judul": "Sosialisasi Kesehatan Warga",
      "isi_pesan":
          "Puskesmas akan mengadakan penyuluhan kesehatan dan pemeriksaan gratis di balai warga.",
      "tanggal_publikasi": "18 Oktober 2025",
      "dibuat_oleh": "Admin Jawara",
      "lampiran_gambar": "a.jpg",
      "lampiran_dokumen": "a.pdf",
    },
    {
      "judul": "Pelatihan Daur Ulang Sampah",
      "isi_pesan":
          "Ayo ikuti pelatihan kreatif mengubah sampah menjadi barang bernilai guna.",
      "tanggal_publikasi": "20 Oktober 2025",
      "dibuat_oleh": "Admin Jawara",
      "lampiran_gambar": "a.jpg",
      "lampiran_dokumen": "a.pdf",
    },
  ];

  static List<Map<String, dynamic>> get semuaDataBroadcast {
    List<Map<String, dynamic>> semuaBroadcast = [];
    for (var broadcast in dataBroadcast) {
      semuaBroadcast.add(Map<String, dynamic>.from(broadcast));
    }
    return semuaBroadcast;
  }

  static Map<String, dynamic>? getKegiatanByNama(String judulBroadcast) {
    try {
      return dataBroadcast.firstWhere(
        (broadcast) => broadcast['judul'] == judulBroadcast,
      );
    } catch (e) {
      return null;
    }
  }
}
