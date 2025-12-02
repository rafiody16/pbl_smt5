import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/warga_provider.dart';
import '../../../models/warga.dart';
import '../../../sidebar/sidebar.dart';
import 'package:intl/intl.dart';

class WargaFormPage extends StatefulWidget {
  final bool isEdit;

  const WargaFormPage({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<WargaFormPage> createState() => _WargaFormPageState();
}

class _WargaFormPageState extends State<WargaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _pekerjaanController = TextEditingController();

  DateTime? _tanggalLahir;
  String? _jenisKelamin;
  String? _agama;
  String? _golonganDarah;
  String? _pendidikanTerakhir;
  String? _statusDomisili = 'Tetap';
  String? _statusHidup = 'Hidup';
  String? _peran;
  int? _keluargaId;
  String _role = 'warga';

  Warga? _existingWarga;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.isEdit) {
      final warga = ModalRoute.of(context)?.settings.arguments as Warga?;
      if (warga != null && _existingWarga == null) {
        _existingWarga = warga;
        _populateForm(warga);
      }
    }
  }

  void _populateForm(Warga warga) {
    _nikController.text = warga.nik;
    _namaController.text = warga.namaLengkap;
    _emailController.text = warga.email ?? '';
    _noTeleponController.text = warga.noTelepon ?? '';
    _tempatLahirController.text = warga.tempatLahir ?? '';
    _pekerjaanController.text = warga.pekerjaan ?? '';
    _tanggalLahir = warga.tanggalLahir;
    _jenisKelamin = warga.jenisKelamin;
    _agama = warga.agama;
    _golonganDarah = warga.golonganDarah;
    _pendidikanTerakhir = warga.pendidikanTerakhir;
    _statusDomisili = warga.statusDomisili;
    _statusHidup = warga.statusHidup;
    _peran = warga.peran;
    _keluargaId = warga.keluargaId;
    _role = warga.role;
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _noTeleponController.dispose();
    _tempatLahirController.dispose();
    _pekerjaanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _tanggalLahir = date;
      });
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final warga = Warga(
      nik: _nikController.text,
      namaLengkap: _namaController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      noTelepon: _noTeleponController.text.isEmpty
          ? null
          : _noTeleponController.text,
      jenisKelamin: _jenisKelamin,
      tempatLahir: _tempatLahirController.text.isEmpty
          ? null
          : _tempatLahirController.text,
      tanggalLahir: _tanggalLahir,
      agama: _agama,
      golonganDarah: _golonganDarah,
      pendidikanTerakhir: _pendidikanTerakhir,
      pekerjaan: _pekerjaanController.text.isEmpty
          ? null
          : _pekerjaanController.text,
      peran: _peran,
      statusDomisili: _statusDomisili ?? 'Tetap',
      statusHidup: _statusHidup ?? 'Hidup',
      keluargaId: _keluargaId,
      role: _role,
      createdAt: _existingWarga?.createdAt ?? DateTime.now(),
    );

    final provider = context.read<WargaProvider>();
    bool success;

    if (widget.isEdit && _existingWarga != null) {
      success = await provider.updateWarga(_existingWarga!.nik, warga);
    } else {
      success = await provider.tambahWarga(warga);
    }

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEdit
                  ? 'Data warga berhasil diupdate'
                  : 'Data warga berhasil ditambahkan',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Terjadi kesalahan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Warga' : 'Tambah Warga'),
      ),
      drawer: const Sidebar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // NIK
            TextFormField(
              controller: _nikController,
              decoration: const InputDecoration(
                labelText: 'NIK *',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              enabled: !widget.isEdit,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIK harus diisi';
                }
                if (value.length != 16) {
                  return 'NIK harus 16 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Nama
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap *',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // No Telepon
            TextFormField(
              controller: _noTeleponController,
              decoration: const InputDecoration(
                labelText: 'No Telepon',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            // Jenis Kelamin
            DropdownButtonFormField<String>(
              value: _jenisKelamin,
              decoration: const InputDecoration(
                labelText: 'Jenis Kelamin',
                prefixIcon: Icon(Icons.wc),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
              ],
              onChanged: (value) {
                setState(() {
                  _jenisKelamin = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Tempat Lahir
            TextFormField(
              controller: _tempatLahirController,
              decoration: const InputDecoration(
                labelText: 'Tempat Lahir',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Tanggal Lahir
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _tanggalLahir != null
                      ? DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(_tanggalLahir!)
                      : 'Pilih tanggal',
                  style: TextStyle(
                    color: _tanggalLahir != null ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Agama
            DropdownButtonFormField<String>(
              value: _agama,
              decoration: const InputDecoration(
                labelText: 'Agama',
                prefixIcon: Icon(Icons.church),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Islam', child: Text('Islam')),
                DropdownMenuItem(value: 'Kristen', child: Text('Kristen')),
                DropdownMenuItem(value: 'Katolik', child: Text('Katolik')),
                DropdownMenuItem(value: 'Hindu', child: Text('Hindu')),
                DropdownMenuItem(value: 'Buddha', child: Text('Buddha')),
                DropdownMenuItem(value: 'Konghucu', child: Text('Konghucu')),
              ],
              onChanged: (value) {
                setState(() {
                  _agama = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Golongan Darah
            DropdownButtonFormField<String>(
              value: _golonganDarah,
              decoration: const InputDecoration(
                labelText: 'Golongan Darah',
                prefixIcon: Icon(Icons.bloodtype),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'A', child: Text('A')),
                DropdownMenuItem(value: 'B', child: Text('B')),
                DropdownMenuItem(value: 'AB', child: Text('AB')),
                DropdownMenuItem(value: 'O', child: Text('O')),
              ],
              onChanged: (value) {
                setState(() {
                  _golonganDarah = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Pendidikan
            DropdownButtonFormField<String>(
              value: _pendidikanTerakhir,
              decoration: const InputDecoration(
                labelText: 'Pendidikan Terakhir',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'SD', child: Text('SD')),
                DropdownMenuItem(value: 'SMP', child: Text('SMP')),
                DropdownMenuItem(value: 'SMA', child: Text('SMA')),
                DropdownMenuItem(value: 'D1', child: Text('D1')),
                DropdownMenuItem(value: 'D2', child: Text('D2')),
                DropdownMenuItem(value: 'D3', child: Text('D3')),
                DropdownMenuItem(value: 'S1', child: Text('S1')),
                DropdownMenuItem(value: 'S2', child: Text('S2')),
                DropdownMenuItem(value: 'S3', child: Text('S3')),
              ],
              onChanged: (value) {
                setState(() {
                  _pendidikanTerakhir = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Pekerjaan
            TextFormField(
              controller: _pekerjaanController,
              decoration: const InputDecoration(
                labelText: 'Pekerjaan',
                prefixIcon: Icon(Icons.work),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Status Domisili
            DropdownButtonFormField<String>(
              value: _statusDomisili,
              decoration: const InputDecoration(
                labelText: 'Status Domisili',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Tetap', child: Text('Tetap')),
                DropdownMenuItem(value: 'Kontrak', child: Text('Kontrak')),
                DropdownMenuItem(value: 'Sementara', child: Text('Sementara')),
              ],
              onChanged: (value) {
                setState(() {
                  _statusDomisili = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Status Hidup
            DropdownButtonFormField<String>(
              value: _statusHidup,
              decoration: const InputDecoration(
                labelText: 'Status Hidup',
                prefixIcon: Icon(Icons.health_and_safety),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Hidup', child: Text('Hidup')),
                DropdownMenuItem(value: 'Meninggal', child: Text('Meninggal')),
              ],
              onChanged: (value) {
                setState(() {
                  _statusHidup = value;
                });
              },
            ),
            const SizedBox(height: 24),
            // Submit Button
            Consumer<WargaProvider>(
              builder: (context, provider, _) {
                return ElevatedButton(
                  onPressed: provider.isLoading ? null : _saveForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.isEdit ? 'Update Data' : 'Simpan Data',
                          style: const TextStyle(fontSize: 16),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
