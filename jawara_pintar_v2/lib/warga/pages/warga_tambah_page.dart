import 'package:flutter/material.dart';
import '../../sidebar/sidebar.dart';
import '../components/form/form_warga.dart';
import '../../../services/toast_service.dart';
import '../../../dashboard/dashboard_page.dart';

class WargaTambahPage extends StatefulWidget {
  const WargaTambahPage({super.key});

  @override
  State<WargaTambahPage> createState() => _WargaTambahPageState();
}

class _WargaTambahPageState extends State<WargaTambahPage> {
  final _formKey = GlobalKey<FormState>();

  String _nama = '';
  String _nik = '';
  String _noTelepon = '';
  String _keluarga = '';
  String _tempatLahir = '';
  String _tanggalLahir = '';
  String _agama = '';
  String _golonganDarah = '';
  String _peran = 'Kepala Keluarga';
  String _pendidikan = '';
  String _pekerjaan = '';
  String _statusHidup = 'Hidup';
  String _statusPenduduk = 'Aktif';
  String _jenisKelamin = 'Laki-laki';

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // TODO: simpan data baru ke database atau state management
      print('Data warga baru:');
      print('Nama: $_nama');
      print('NIK: $_nik');
      print('No Telepon: $_noTelepon');
      print('Keluarga: $_keluarga');
      print('Tempat Lahir: $_tempatLahir');
      print('Tanggal Lahir: $_tanggalLahir');
      print('Agama: $_agama');
      print('Golongan Darah: $_golonganDarah');
      print('Peran: $_peran');
      print('Pendidikan: $_pendidikan');
      print('Pekerjaan: $_pekerjaan');
      print('Status Hidup: $_statusHidup');
      print('Status Penduduk: $_statusPenduduk');
      print('Jenis Kelamin: $_jenisKelamin');

      ToastService.showSuccess(context, "Data warga berhasil ditambahkan");

      Future.delayed(const Duration(milliseconds: 1500), () {
        _navigateToDashboard();
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const DashboardPage(userEmail: 'admin@jawara.com')
      ),
      (route) => false,
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _nama = '';
      _nik = '';
      _noTelepon = '';
      _keluarga = '';
      _tempatLahir = '';
      _tanggalLahir = '';
      _agama = '';
      _golonganDarah = '';
      _peran = 'Kepala Keluarga';
      _pendidikan = '';
      _pekerjaan = '';
      _statusHidup = 'Hidup';
      _statusPenduduk = 'Aktif';
      _jenisKelamin = 'Laki-laki';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form telah direset'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Map<String, dynamic> get _formData {
    return {
      'nama': _nama,
      'nik': _nik,
      'no_telepon': _noTelepon,
      'keluarga': _keluarga,
      'tempat_lahir': _tempatLahir,
      'tanggal_lahir': _tanggalLahir,
      'agama': _agama,
      'golongan_darah': _golonganDarah,
      'peran': _peran,
      'pendidikan': _pendidikan,
      'pekerjaan': _pekerjaan,
      'status_hidup': _statusHidup,
      'status_domisili': _statusPenduduk,
      'jenis_kelamin': _jenisKelamin,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          "Tambah Warga",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _navigateToDashboard,
        ),
      ),
      drawer: const Sidebar(userEmail: 'admin@jawara.com'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.person_add, color: Colors.blue, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Tambah Warga Baru",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 24),

                    FormWarga(
                      initialData: _formData,
                      formKey: _formKey,
                      onNamaChanged: (value) => _nama = value,
                      onNikChanged: (value) => _nik = value,
                      onNoTeleponChanged: (value) => _noTelepon = value,
                      onKeluargaChanged: (value) => setState(() => _keluarga = value),
                      onTempatLahirChanged: (value) => _tempatLahir = value,
                      onTanggalLahirChanged: (date) => setState(() => _tanggalLahir = date),
                      onAgamaChanged: (value) => setState(() => _agama = value),
                      onGolonganDarahChanged: (value) => setState(() => _golonganDarah = value),
                      onPeranChanged: (value) => setState(() => _peran = value),
                      onPendidikanChanged: (value) => setState(() => _pendidikan = value),
                      onPekerjaanChanged: (value) => setState(() => _pekerjaan = value),
                      onStatusHidupChanged: (value) => setState(() => _statusHidup = value),
                      onStatusPendudukChanged: (value) => setState(() => _statusPenduduk = value),
                      onJenisKelaminChanged: (value) => setState(() => _jenisKelamin = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Reset"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Tambah"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}