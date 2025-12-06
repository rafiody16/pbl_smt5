import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'fields/nama_lengkap_field.dart';
import 'fields/nik_field.dart';
import 'fields/email_field.dart';
import 'fields/telepon_field.dart';
import 'fields/password_field.dart';
import 'fields/konfirmasi_password_field.dart';
import 'fields/jenis_kelamin_field.dart';
import 'fields/keluarga_field.dart';
import 'fields/rumah_field.dart';
import 'fields/alamat_rumah_field.dart';
import 'fields/status_rumah_field.dart';
import 'fields/upload_identitas_field.dart';
import 'fields/tempat_lahir_field.dart';
import 'fields/tanggal_lahir_field.dart';
import 'fields/agama_field.dart';
import 'fields/golongan_darah_field.dart';
import 'fields/pendidikan_field.dart';
import 'fields/pekerjaan_field.dart';
import 'fields/peran_field.dart';
import '../services/toast_service.dart';
import '../providers/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final Map<String, dynamic> _formData = {};
  int _currentStep = 0;
  final TextEditingController _alamatController = TextEditingController();

  // untuk masing" field yang butuh state reset
  final GlobalKey _jenisKelaminKey = GlobalKey();
  final GlobalKey _keluargaKey = GlobalKey();
  final GlobalKey _rumahKey = GlobalKey();
  final GlobalKey _statusRumahKey = GlobalKey();
  final GlobalKey _uploadIdentitasKey = GlobalKey();
  final GlobalKey _tanggalLahirKey = GlobalKey();
  final GlobalKey _agamaKey = GlobalKey();
  final GlobalKey _golonganDarahKey = GlobalKey();
  final GlobalKey _pendidikanKey = GlobalKey();
  final GlobalKey _peranKey = GlobalKey();

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }

  void _resetForm() {
    // reset all form states
    for (var key in _formKeys) {
      key.currentState?.reset();
    }

    // reset stateful fields
    (_jenisKelaminKey.currentState as dynamic)?.resetState();
    (_keluargaKey.currentState as dynamic)?.resetState();
    (_rumahKey.currentState as dynamic)?.resetState();
    (_statusRumahKey.currentState as dynamic)?.resetState();
    (_uploadIdentitasKey.currentState as dynamic)?.resetState();
    (_tanggalLahirKey.currentState as dynamic)?.resetState();
    (_agamaKey.currentState as dynamic)?.resetState();
    (_golonganDarahKey.currentState as dynamic)?.resetState();
    (_pendidikanKey.currentState as dynamic)?.resetState();
    (_peranKey.currentState as dynamic)?.resetState();

    _alamatController.clear();

    // clear form data
    _formData.clear();

    // reset to first step
    setState(() {
      _currentStep = 0;
    });
  }

  bool _validateCurrentStep() {
    return _formKeys[_currentStep].currentState?.validate() ?? false;
  }

  void _saveCurrentStep() {
    _formKeys[_currentStep].currentState?.save();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      _saveCurrentStep();
      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _register() async {
    // Validate and save last step
    if (_validateCurrentStep()) {
      _saveCurrentStep();

      // val rumah ATAU alamat rumah harus terisi
      if ((_formData['rumahId'] == null) &&
          (_formData['alamatRumah'] == null ||
              _formData['alamatRumah'].isEmpty)) {
        ToastService.showError(
          context,
          "Harap pilih alamat rumah dari daftar ATAU isi alamat rumah!",
        );
        return;
      }

      // val foto identitas wajib diunggah
      if (_formData['fotoIdentitas'] == null ||
          _formData['fotoIdentitas'].isEmpty) {
        ToastService.showError(context, "Foto identitas wajib diunggah!");
        return;
      }

      // jika semua field required terisi
      if (_formData['namaLengkap'] != null &&
          _formData['nik'] != null &&
          _formData['email'] != null &&
          _formData['telepon'] != null &&
          _formData['password'] != null &&
          _formData['konfirmasiPassword'] != null &&
          _formData['jenisKelamin'] != null &&
          _formData['tempatLahir'] != null &&
          _formData['tanggalLahir'] != null &&
          _formData['agama'] != null &&
          _formData['statusRumah'] != null) {
        // konfir password
        if (_formData['password'] != _formData['konfirmasiPassword']) {
          ToastService.showError(
            context,
            "Password dan konfirmasi password tidak sama!",
          );
          return;
        }

        // proses registrasi dengan Supabase Auth
        final authProvider = context.read<AuthProvider>();

        final success = await authProvider.signUp(
          email: _formData['email'],
          password: _formData['password'],
          nik: _formData['nik'],
          namaLengkap: _formData['namaLengkap'],
          additionalData: {
            'no_telepon': _formData['telepon'],
            'jenis_kelamin': _formData['jenisKelamin'],
            'tempat_lahir': _formData['tempatLahir'],
            'tanggal_lahir': _formData['tanggalLahir'],
            'agama': _formData['agama'],
            'golongan_darah': _formData['golonganDarah'],
            'pendidikan_terakhir': _formData['pendidikanTerakhir'],
            'pekerjaan': _formData['pekerjaan'],
            'peran': _formData['peran'],
            'status_domisili': _formData['statusRumah'],
            'foto_url': _formData['fotoIdentitas'],
            'keluarga_id': _formData['keluargaId'],
            'rumah_id': _formData['rumahId'],
            'alamat_rumah': _formData['alamatRumah'],
          },
        );

        if (mounted) {
          if (success) {
            ToastService.showSuccess(context, "Pendaftaran berhasil!");

            // reset form setelah berhasil
            _resetForm();

            // Navigate to login
            await Future.delayed(const Duration(seconds: 2));
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          } else {
            ToastService.showError(
              context,
              authProvider.errorMessage ?? 'Pendaftaran gagal',
            );
          }
        }
      } else {
        ToastService.showError(
          context,
          "Harap lengkapi semua field yang wajib diisi!",
        );
      }
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? Colors.blue
                    : isCompleted
                    ? Colors.green
                    : Colors.grey.shade300,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            if (index < 3)
              Container(
                width: 40,
                height: 2,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        );
      }),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return "Informasi Akun";
      case 1:
        return "Informasi Pribadi";
      case 2:
        return "Informasi Tambahan";
      case 3:
        return "Informasi Keluarga dan Alamat";
      default:
        return "";
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 0:
        return "Buat akun dengan email dan password";
      case 1:
        return "Lengkapi data pribadi Anda";
      case 2:
        return "Informasi pendukung";
      case 3:
        return "Data keluarga dan alamat";
      default:
        return "";
    }
  }

  Widget _buildStep0() {
    return Form(
      key: _formKeys[0],
      child: Column(
        children: [
          EmailField(
            initialValue: _formData['email'],
            onSaved: (value) => _formData['email'] = value,
          ),
          const SizedBox(height: 16),
          PasswordField(onSaved: (value) => _formData['password'] = value),
          const SizedBox(height: 16),
          KonfirmasiPasswordField(
            onSaved: (value) => _formData['konfirmasiPassword'] = value,
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeys[1],
      child: Column(
        children: [
          NikField(
            initialValue: _formData['nik'],
            onSaved: (value) => _formData['nik'] = value,
          ),
          const SizedBox(height: 16),
          NamaLengkapField(
            initialValue: _formData['namaLengkap'],
            onSaved: (value) => _formData['namaLengkap'] = value,
          ),
          const SizedBox(height: 16),
          JenisKelaminField(
            key: _jenisKelaminKey,
            value: _formData['jenisKelamin'],
            onSaved: (value) => _formData['jenisKelamin'] = value,
          ),
          const SizedBox(height: 16),
          TeleponField(
            initialValue: _formData['telepon'],
            onSaved: (value) => _formData['telepon'] = value,
          ),
          const SizedBox(height: 16),
          UploadIdentitasField(
            key: _uploadIdentitasKey,
            initialValue: _formData['fotoIdentitas'],
            onSaved: (value) => _formData['fotoIdentitas'] = value,
          ),
          const SizedBox(height: 16),
          TanggalLahirField(
            key: _tanggalLahirKey,
            initialValue: _formData['tanggalLahir'],
            onSaved: (value) => _formData['tanggalLahir'] = value,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeys[2],
      child: Column(
        children: [
          TempatLahirField(
            initialValue: _formData['tempatLahir'],
            onSaved: (value) => _formData['tempatLahir'] = value,
          ),
          const SizedBox(height: 16),
          AgamaField(
            key: _agamaKey,
            value: _formData['agama'],
            onSaved: (value) => _formData['agama'] = value,
          ),
          const SizedBox(height: 16),
          GolonganDarahField(
            key: _golonganDarahKey,
            value: _formData['golonganDarah'],
            onSaved: (value) => _formData['golonganDarah'] = value,
          ),
          const SizedBox(height: 16),
          PendidikanField(
            key: _pendidikanKey,
            value: _formData['pendidikanTerakhir'],
            onSaved: (value) => _formData['pendidikanTerakhir'] = value,
          ),
          const SizedBox(height: 16),
          PekerjaanField(
            initialValue: _formData['pekerjaan'],
            onSaved: (value) => _formData['pekerjaan'] = value,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _formKeys[3],
      child: Column(
        children: [
          KeluargaField(
            key: _keluargaKey,
            value: _formData['keluargaId'],
            onSaved: (value) => _formData['keluargaId'] = value,
          ),
          const SizedBox(height: 16),
          PeranField(
            key: _peranKey,
            value: _formData['peran'],
            onSaved: (value) => _formData['peran'] = value,
          ),
          const SizedBox(height: 16),
          RumahField(
            key: _rumahKey,
            initialValue: _formData['rumahId'],
            onSelected: (id, alamat) {
              _formData['rumahId'] = id;
              _formData['alamatRumah'] = alamat;
              if (alamat != null) {
                _alamatController.text = alamat;
              } else {
                _alamatController.clear();
              }
            },
          ),
          const SizedBox(height: 16),
          AlamatRumahField(
            controller: _alamatController,
            readOnly: _formData['rumahId'] != null,
            onSaved: (value) => _formData['alamatRumah'] = value,
          ),
          const SizedBox(height: 16),
          StatusRumahField(
            key: _statusRumahKey,
            value: _formData['statusRumah'],
            onSaved: (value) => _formData['statusRumah'] = value,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Center(
            child: Text(
              "Daftar Akun",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          _buildStepIndicator(),
          const SizedBox(height: 24),
          Center(
            child: Text(
              _getStepTitle(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _getStepDescription(),
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),

          // Form content based on current step
          if (_currentStep == 0) _buildStep0(),
          if (_currentStep == 1) _buildStep1(),
          if (_currentStep == 2) _buildStep2(),
          if (_currentStep == 3) _buildStep3(),

          const SizedBox(height: 24),

          // Navigation buttons
          Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Kembali"),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 16),
              Expanded(
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : (_currentStep < 3 ? _nextStep : _register),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _currentStep < 3 ? "Lanjut" : "Buat Akun",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
