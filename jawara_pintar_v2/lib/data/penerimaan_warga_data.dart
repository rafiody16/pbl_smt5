class PenerimaanWargaData {
  static final List<Map<String, dynamic>> dataPendaftaran = [
    {
      'no': 1,
      'nama': 'Rendha Putra Rahmadya',
      'nik': '35051',
      'email': 'rendhazuper@gmail.com',
      'jenis_kelamin': 'L',
      'foto_identitas': 'foto_rendha.jpg',
      'status_registrasi': 'Diterima',
    },
    {
      'no': 2,
      'nama': 'Anti Micin',
      'nik': '12345',
      'email': 'antimicin3@gmail.com',
      'jenis_kelamin': 'L',
      'foto_identitas': 'foto_anti.jpg',
      'status_registrasi': 'Diterima',
    },
    {
      'no': 3,
      'nama': 'Ijat',
      'nik': '20252',
      'email': 'ijat1@gmail.com',
      'jenis_kelamin': 'L',
      'foto_identitas': 'foto_ijat.jpg',
      'status_registrasi': 'Nonaktif',
    },
    {
      'no': 4,
      'nama': 'Raudhi Fridaus Naufal',
      'nik': '32011',
      'email': 'raudhilfirdausn@gmail.com',
      'jenis_kelamin': 'L',
      'foto_identitas': 'foto_raudhi.jpg',
      'status_registrasi': 'Diterima',
    },
    {
      'no': 5,
      'nama': 'varizky naidiba rimra',
      'nik': '13711',
      'email': 'afsafas@gmail.com',
      'jenis_kelamin': 'L',
      'foto_identitas': 'foto_varizky1.jpg',
      'status_registrasi': 'Diterima',
    },
    {
      'no': 6,
      'nama': 'Varizky Naidiba Rimra',
      'nik': '13711',
      'email': 'varidvrrr@gmail.com',
      'jenis_kelamin': 'L',
      'foto_identitas': 'foto_varizky2.jpg',
      'status_registrasi': 'Pending',
    },
  ];

  static List<Map<String, dynamic>> get semuaDataPendaftaran {
    return dataPendaftaran;
  }

  static Map<String, dynamic>? getPendaftaranByNIK(String nik) {
    try {
      return dataPendaftaran.firstWhere(
        (pendaftaran) => pendaftaran['nik'] == nik,
      );
    } catch (e) {
      return null;
    }
  }
}