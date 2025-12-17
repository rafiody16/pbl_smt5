import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/warga.dart';
import '../../../providers/warga_provider.dart';
import '../../../services/toast_service.dart';
import '../../../register/fields/email_field.dart';
import '../../../register/fields/password_field.dart';
import '../../../register/fields/role_sistem_field.dart';

class BuatAkunWargaPage extends StatefulWidget {
  const BuatAkunWargaPage({super.key});

  @override
  State<BuatAkunWargaPage> createState() => _BuatAkunWargaPageState();
}

class _BuatAkunWargaPageState extends State<BuatAkunWargaPage> {
  final _formKey = GlobalKey<FormState>();

  Warga? _selectedWarga;
  String? _email;
  String? _password;
  String? _role;

  @override
  void initState() {
    super.initState();
    final provider = context.read<WargaProvider>();
    if (provider.wargaList.isEmpty) {
      // best-effort load
      provider.loadWarga();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_selectedWarga == null) {
      ToastService.showError(context, 'Pilih warga terlebih dahulu');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final provider = context.read<WargaProvider>();

      // Bangun kembali objek warga dengan email/role terbaru jika diedit di form
      final warga = Warga(
        nik: _selectedWarga!.nik,
        userId: _selectedWarga!.userId,
        keluargaId: _selectedWarga!.keluargaId,
        namaLengkap: _selectedWarga!.namaLengkap,
        email: _email ?? _selectedWarga!.email,
        noTelepon: _selectedWarga!.noTelepon,
        jenisKelamin: _selectedWarga!.jenisKelamin,
        tempatLahir: _selectedWarga!.tempatLahir,
        tanggalLahir: _selectedWarga!.tanggalLahir,
        agama: _selectedWarga!.agama,
        golonganDarah: _selectedWarga!.golonganDarah,
        pendidikanTerakhir: _selectedWarga!.pendidikanTerakhir,
        pekerjaan: _selectedWarga!.pekerjaan,
        peran: _selectedWarga!.peran,
        statusDomisili: _selectedWarga!.statusDomisili,
        statusHidup: _selectedWarga!.statusHidup,
        fotoUrl: _selectedWarga!.fotoUrl,
        role: _role ?? _selectedWarga!.role,
        createdAt: _selectedWarga!.createdAt,
      );

      final ok = await provider.tambahWargaWithAccount(
        warga: warga,
        email: _email ?? _selectedWarga!.email ?? '',
        password: _password!,
      );

      Navigator.pop(context); // close loading

      if (ok) {
        ToastService.showSuccess(context, 'Akun berhasil dibuat');
        if (mounted) Navigator.pop(context);
      } else {
        ToastService.showError(
          context,
          provider.errorMessage ?? 'Gagal membuat akun',
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ToastService.showError(context, 'Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Akun Warga')),
      body: Consumer<WargaProvider>(
        builder: (context, provider, _) {
          final calonAkun = provider.wargaList
              .where((w) => w.userId == null || w.userId!.isEmpty)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<Warga>(
                    decoration: const InputDecoration(
                      labelText: 'Pilih Warga',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_search),
                    ),
                    items: calonAkun
                        .map(
                          (w) => DropdownMenuItem(
                            value: w,
                            child: Text('${w.namaLengkap} • ${w.nik}'),
                          ),
                        )
                        .toList(),
                    value: _selectedWarga,
                    onChanged: (w) {
                      setState(() {
                        _selectedWarga = w;
                        _email = w?.email; // prefill
                        _role = w?.role;
                      });
                    },
                    validator: (v) => v == null ? 'Wajib dipilih' : null,
                  ),
                  const SizedBox(height: 16),
                  EmailField(
                    initialValue: _email,
                    onSaved: (val) => _email = val,
                  ),
                  const SizedBox(height: 16),
                  PasswordField(onSaved: (val) => _password = val),
                  const SizedBox(height: 16),
                  RoleSistemField(value: _role, onSaved: (val) => _role = val),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: provider.isLoading ? null : _submit,
                          icon: const Icon(Icons.check),
                          label: const Text('Buat Akun'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
