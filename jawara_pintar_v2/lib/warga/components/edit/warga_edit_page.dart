import 'package:flutter/material.dart';
import '../form/form_warga.dart';
import '../../../../services/toast_service.dart';
import '../../../../data/warga_data.dart';

class WargaEditPage extends StatefulWidget {
  final Map<String, dynamic> warga;

  const WargaEditPage({
    super.key,
    required this.warga,
  });

  @override
  State<WargaEditPage> createState() => _WargaEditPageState();
}

class _WargaEditPageState extends State<WargaEditPage> {
  final _formKey = GlobalKey<FormState>();

  late String _nama;
  late String _nik;
  late String _noTelepon;
  late String? _keluarga;
  late String _tempatLahir;
  late String _tanggalLahir;
  late String _agama;
  late String _golonganDarah;
  late String _peran;
  late String _pendidikan;
  late String _pekerjaan;
  late String _statusHidup;
  late String _statusPenduduk;
  late String _jenisKelamin;

  String? _getKeluargaName() {
    for (var keluarga in WargaData.dataKeluarga) {
      var anggota = keluarga['anggota'] as List;
      var found = anggota.cast<Map<String, dynamic>>().firstWhere(
        (anggota) => anggota['nik'] == widget.warga['nik'],
        orElse: () => <String, dynamic>{},
      );
      if (found.isNotEmpty) {
        return keluarga['nama_keluarga'] as String;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _nama = widget.warga['nama'] ?? '';
    _nik = widget.warga['nik'] ?? '';
    _noTelepon = widget.warga['no_telepon'] ?? '';
    _keluarga = _getKeluargaName();
    _tempatLahir = widget.warga['tempat_lahir'] ?? '';
    _tanggalLahir = widget.warga['tanggal_lahir'] ?? '';
    _agama = widget.warga['agama'] ?? '';
    _golonganDarah = widget.warga['golongan_darah'] ?? '';
    _peran = widget.warga['peran'] ?? 'Kepala Keluarga';
    _pendidikan = widget.warga['pendidikan'] ?? '';
    _pekerjaan = widget.warga['pekerjaan'] ?? '';
    _statusHidup = widget.warga['status_hidup'] ?? 'Hidup';
    _statusPenduduk = widget.warga['status_domisili'] ?? 'Aktif';
    _jenisKelamin = widget.warga['jenis_kelamin'] ?? 'Laki-laki';
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // TODO: simpan data ke database atau state management
      print('Data disimpan:');
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

      ToastService.showSuccess(context, "Data warga berhasil diperbarui");

      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pop();
      });
    }
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
      appBar: AppBar(
        title: const Text(
          "Edit Warga",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey[50],
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
                          child: const Icon(Icons.edit, color: Colors.blue, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Edit Warga",
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
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}