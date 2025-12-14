import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/providers/auth_provider.dart';
import 'package:jawara_pintar_v2/sidebar/components/sidebar_menu.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/warga_provider.dart';
import '../../../models/warga.dart';
import '../../../sidebar/sidebar.dart';
import '../../../services/toast_service.dart';
import '../../../register/fields/nama_lengkap_field.dart';
import '../../../register/fields/nik_field.dart';
import '../../../register/fields/email_field.dart';
import '../../../register/fields/telepon_field.dart';
import '../../../register/fields/password_field.dart';
import '../../../register/fields/jenis_kelamin_field.dart';
import '../../../register/fields/keluarga_field.dart';
import '../../../register/fields/peran_field.dart';
import '../../../register/fields/pendidikan_field.dart';
import '../../../register/fields/pekerjaan_field.dart';
import '../../../register/fields/upload_identitas_field.dart';
import '../../../register/fields/tempat_lahir_field.dart';
import '../../../register/fields/tanggal_lahir_field.dart';
import '../../../register/fields/agama_field.dart';
import '../../../register/fields/golongan_darah_field.dart';
import '../../../register/fields/alamat_rumah_field.dart';
import '../../../register/fields/rumah_field.dart';
import '../../../register/fields/status_rumah_field.dart';
import '../../../warga/components/form/fields/status_hidup_field.dart';

class WargaFormPage extends StatefulWidget {
  final bool isEdit;

  const WargaFormPage({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<WargaFormPage> createState() => _WargaFormPageState();
}

class _WargaFormPageState extends State<WargaFormPage> {
  // Global Keys untuk validasi per step
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Step 1: Pribadi Utama
    GlobalKey<FormState>(), // Step 2: Detail
    GlobalKey<FormState>(), // Step 3: Keluarga & Status
    GlobalKey<FormState>(), // Step 4: Akun (Optional)
  ];

  int _currentStep = 0;
  Warga? _existingWarga;

  // Data State
  final Map<String, dynamic> _formData = {};

  // Controller khusus untuk logic tambahan (misal password)
  String? _password;
  bool _createAccount = false;

  // Keys dan Controllers untuk Step 3
  final GlobalKey<State> _rumahKey = GlobalKey<State>();
  final GlobalKey<State> _statusRumahKey = GlobalKey<State>();
  late TextEditingController _alamatController;

  @override
  void initState() {
    super.initState();
    _alamatController = TextEditingController();
  }

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }

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
    setState(() {
      _formData['nik'] = warga.nik;
      _formData['namaLengkap'] = warga.namaLengkap;
      _formData['email'] = warga.email;
      _formData['telepon'] = warga.noTelepon;
      _formData['jenisKelamin'] = warga.jenisKelamin;
      _formData['fotoIdentitas'] = warga.fotoUrl; // URL foto lama

      _formData['tempatLahir'] = warga.tempatLahir;
      _formData['tanggalLahir'] = warga.tanggalLahir != null
          ? DateFormat('yyyy-MM-dd').format(warga.tanggalLahir!)
          : null;
      _formData['agama'] = warga.agama;
      _formData['golonganDarah'] = warga.golonganDarah;
      _formData['pendidikanTerakhir'] = warga.pendidikanTerakhir;
      _formData['pekerjaan'] = warga.pekerjaan;

      _formData['keluargaId'] = warga.keluargaId; // Pastikan ini int
      _formData['peran'] = warga.peran;
      _formData['statusDomisili'] = warga.statusDomisili;
      _formData['statusHidup'] = warga.statusHidup;
    });
  }

  // --- Logic Navigasi Step ---

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
        setState(() => _currentStep++);
      } else {
        _submitForm();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // --- Logic Submit ---

  Future<void> _submitForm() async {
    // Validasi tambahan untuk step terakhir (Akun)
    if (_createAccount && !widget.isEdit) {
      if ((_formData['email'] == null || _formData['email'].isEmpty) ||
          (_password == null || _password!.isEmpty)) {
        ToastService.showError(
          context,
          "Email dan Password wajib diisi untuk membuat akun",
        );
        return;
      }
    }

    // Tampilkan Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final provider = context.read<WargaProvider>();

      // Construct Object Warga
      final wargaObj = Warga(
        nik: _formData['nik'],
        namaLengkap: _formData['namaLengkap'],
        email: _formData['email'],
        noTelepon: _formData['telepon'],
        jenisKelamin: _formData['jenisKelamin'],
        tempatLahir: _formData['tempatLahir'],
        tanggalLahir: _formData['tanggalLahir'] != null
            ? DateTime.parse(_formData['tanggalLahir'])
            : null,
        agama: _formData['agama'],
        golonganDarah: _formData['golonganDarah'],
        pendidikanTerakhir: _formData['pendidikanTerakhir'],
        pekerjaan: _formData['pekerjaan'],
        peran: _formData['peran'],
        statusDomisili: _formData['statusDomisili'] ?? 'Tetap',
        statusHidup: _formData['statusHidup'] ?? 'Hidup',
        keluargaId: _formData['keluargaId'], // Dropdown mengembalikan int?
        fotoUrl: _formData['fotoIdentitas'],
        role: 'warga',
        createdAt: _existingWarga?.createdAt ?? DateTime.now(),
      );

      bool success;
      if (widget.isEdit && _existingWarga != null) {
        success = await provider.updateWarga(_existingWarga!.nik, wargaObj);
      } else {
        if (_createAccount) {
          success = await provider.tambahWargaWithAccount(
            warga: wargaObj,
            email: _formData['email'],
            password: _password!,
          );
        } else {
          success = await provider.tambahWarga(wargaObj);
        }
      }

      Navigator.pop(context); // Tutup loading dialog

      if (success) {
        ToastService.showSuccess(
          context,
          widget.isEdit
              ? "Data warga berhasil diperbarui"
              : "Warga berhasil ditambahkan",
        );
        // Gunakan pushReplacementNamed untuk navigate ke list dengan aman
        Navigator.pushReplacementNamed(context, '/warga/list');
      } else {
        ToastService.showError(
          context,
          provider.errorMessage ?? "Gagal menyimpan data",
        );
      }
    } catch (e) {
      Navigator.pop(context); // Tutup loading dialog
      ToastService.showError(context, "Terjadi kesalahan: $e");
    }
  }

  // --- UI Components ---

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return "Identitas Utama";
      case 1:
        return "Detail Pribadi";
      case 2:
        return "Keluarga & Alamat";
      case 3:
        return widget.isEdit ? "Konfirmasi" : "Akun Login";
      default:
        return "";
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
                    : (isCompleted ? Colors.green : Colors.grey.shade300),
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

  // --- Form Steps ---

  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: Column(
        children: [
          NikField(
            initialValue: _formData['nik'],
            onSaved: (val) => _formData['nik'] = val,
          ),
          const SizedBox(height: 16),
          NamaLengkapField(
            initialValue: _formData['namaLengkap'],
            onSaved: (val) => _formData['namaLengkap'] = val,
          ),
          const SizedBox(height: 16),
          JenisKelaminField(
            value: _formData['jenisKelamin'],
            onSaved: (val) => _formData['jenisKelamin'] = val,
          ),
          const SizedBox(height: 16),
          TeleponField(
            initialValue: _formData['telepon'],
            onSaved: (val) => _formData['telepon'] = val,
          ),
          const SizedBox(height: 16),
          UploadIdentitasField(
            initialValue: _formData['fotoIdentitas'],
            onSaved: (val) => _formData['fotoIdentitas'] = val,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeys[1],
      child: Column(
        children: [
          TempatLahirField(
            initialValue: _formData['tempatLahir'],
            onSaved: (val) => _formData['tempatLahir'] = val,
          ),
          const SizedBox(height: 16),
          TanggalLahirField(
            initialValue: _formData['tanggalLahir'],
            onSaved: (val) => _formData['tanggalLahir'] = val,
          ),
          const SizedBox(height: 16),
          AgamaField(
            value: _formData['agama'],
            onSaved: (val) => _formData['agama'] = val,
          ),
          const SizedBox(height: 16),
          GolonganDarahField(
            value: _formData['golonganDarah'],
            onSaved: (val) => _formData['golonganDarah'] = val,
          ),
          const SizedBox(height: 16),
          PendidikanField(
            value: _formData['pendidikanTerakhir'],
            onSaved: (val) => _formData['pendidikanTerakhir'] = val,
          ),
          const SizedBox(height: 16),
          PekerjaanField(
            initialValue: _formData['pekerjaan'],
            onSaved: (val) => _formData['pekerjaan'] = val,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _formKeys[2],
      child: Column(
        children: [
          KeluargaField(
            value: _formData['keluargaId'],
            onSaved: (val) => _formData['keluargaId'] = val,
          ),
          const SizedBox(height: 16),
          PeranField(
            value: _formData['peran'],
            onSaved: (val) => _formData['peran'] = val,
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
          const SizedBox(height: 16),
          StatusHidupField(
            value: _formData['statusHidup'] ?? 'Hidup',
            onChanged: (val) => _formData['statusHidup'] = val,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    if (widget.isEdit) {
      // PERBAIKAN: Bungkus dengan Form agar _formKeys[3] terdeteksi
      return Form(
        key: _formKeys[3],
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
              SizedBox(height: 16),
              Text("Data siap diperbarui.", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    // Kode untuk mode Tambah Baru (Create Account) biarkan tetap seperti semula
    return Form(
      key: _formKeys[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Buatkan Akun Login?"),
            subtitle: const Text(
              "Warga dapat login menggunakan Email & Password ini.",
            ),
            value: _createAccount,
            onChanged: (val) {
              setState(() => _createAccount = val ?? false);
            },
          ),
          if (_createAccount) ...[
            const Divider(),
            const SizedBox(height: 16),
            EmailField(
              initialValue: _formData['email'],
              onSaved: (val) => _formData['email'] = val,
            ),
            const SizedBox(height: 16),
            PasswordField(onSaved: (val) => _password = val),
            const SizedBox(height: 8),
            const Text(
              "* Password minimal 6 karakter",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
          if (!_createAccount)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Klik Simpan untuk menambahkan data warga tanpa akun login.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SidebarMenu(userRole: authProvider.userRole);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Data Warga' : 'Tambah Warga Baru',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // Gunakan pushReplacementNamed untuk kembali ke list dengan aman
            Navigator.pushReplacementNamed(context, '/warga/list');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildStepIndicator(),
                const SizedBox(height: 24),

                Text(
                  _getStepTitle(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Render Content based on step
                if (_currentStep == 0) _buildStep1(),
                if (_currentStep == 1) _buildStep2(),
                if (_currentStep == 2) _buildStep3(),
                if (_currentStep == 3) _buildStep4(),

                const SizedBox(height: 32),

                // Navigation Buttons
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
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _currentStep < 3 ? "Lanjut" : "Simpan Data",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
