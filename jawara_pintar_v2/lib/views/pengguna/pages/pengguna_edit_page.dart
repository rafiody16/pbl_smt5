import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/warga.dart';
import '../../../providers/warga_provider.dart';
import '../../../services/toast_service.dart';
import '../../../register/fields/email_field.dart';
import '../../../register/fields/role_sistem_field.dart';

class PenggunaEditPage extends StatefulWidget {
  const PenggunaEditPage({super.key});

  @override
  State<PenggunaEditPage> createState() => _PenggunaEditPageState();
}

class _PenggunaEditPageState extends State<PenggunaEditPage> {
  final _formKey = GlobalKey<FormState>();
  Warga? _pengguna;
  String? _email;
  String? _role;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pengguna == null) {
      _pengguna = ModalRoute.of(context)?.settings.arguments as Warga?;
      if (_pengguna != null) {
        _email = _pengguna!.email;
        _role = _pengguna!.role;
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_pengguna == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final provider = context.read<WargaProvider>();

      // Update warga dengan email dan role baru
      final updatedWarga = Warga(
        nik: _pengguna!.nik,
        userId: _pengguna!.userId,
        keluargaId: _pengguna!.keluargaId,
        namaLengkap: _pengguna!.namaLengkap,
        email: _email,
        noTelepon: _pengguna!.noTelepon,
        jenisKelamin: _pengguna!.jenisKelamin,
        tempatLahir: _pengguna!.tempatLahir,
        tanggalLahir: _pengguna!.tanggalLahir,
        agama: _pengguna!.agama,
        golonganDarah: _pengguna!.golonganDarah,
        pendidikanTerakhir: _pengguna!.pendidikanTerakhir,
        pekerjaan: _pengguna!.pekerjaan,
        peran: _pengguna!.peran,
        statusDomisili: _pengguna!.statusDomisili,
        statusHidup: _pengguna!.statusHidup,
        fotoUrl: _pengguna!.fotoUrl,
        role: _role ?? _pengguna!.role,
        createdAt: _pengguna!.createdAt,
      );

      final ok = await provider.updateWarga(_pengguna!.nik, updatedWarga);

      Navigator.pop(context); // close loading

      if (ok) {
        ToastService.showSuccess(context, 'Data pengguna berhasil diperbarui');
        if (mounted) Navigator.pop(context); // kembali ke detail/list
      } else {
        ToastService.showError(
          context,
          provider.errorMessage ?? 'Gagal memperbarui data pengguna',
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ToastService.showError(context, 'Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pengguna == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Pengguna')),
        body: const Center(child: Text('Data pengguna tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengguna')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _pengguna!.namaLengkap,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          Text(
                            'NIK: ${_pengguna!.nik}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form fields
              const Text(
                'Email Pengguna',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              EmailField(initialValue: _email, onSaved: (val) => _email = val),
              const SizedBox(height: 24),

              const Text(
                'Role Sistem',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RoleSistemField(value: _role, onSaved: (val) => _role = val),
              const SizedBox(height: 32),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
