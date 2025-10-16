import 'package:flutter/material.dart';
import 'fields/nama_lengkap_field.dart';
import 'fields/nik_field.dart';
import 'fields/email_field.dart';
import 'fields/telepon_field.dart';
import 'fields/password_field.dart';
import 'fields/konfirmasi_password_field.dart';
import 'fields/jenis_kelamin_field.dart';
import 'fields/rumah_field.dart';
import 'fields/alamat_rumah_field.dart';
import 'fields/status_rumah_field.dart';
import 'fields/upload_identitas_field.dart';
import '../services/toast_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  
  // untuk masing" field yang butuh state reset
  final GlobalKey _jenisKelaminKey = GlobalKey();
  final GlobalKey _rumahKey = GlobalKey();
  final GlobalKey _statusRumahKey = GlobalKey();
  final GlobalKey _uploadIdentitasKey = GlobalKey();

  void _resetForm() {
    // form state
    _formKey.currentState?.reset();
    
    // reset stateful fields
    (_jenisKelaminKey.currentState as dynamic)?.resetState();
    (_rumahKey.currentState as dynamic)?.resetState();
    (_statusRumahKey.currentState as dynamic)?.resetState();
    (_uploadIdentitasKey.currentState as dynamic)?.resetState();
    
    // clear form data
    _formData.clear();
    
    // force rebuild
    setState(() {});
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // val rumah ATAU alamat rumah harus terisi
      if ((_formData['rumah'] == null || _formData['rumah'].isEmpty) && 
          (_formData['alamatRumah'] == null || _formData['alamatRumah'].isEmpty)) {
        ToastService.showError(context, "Harap pilih rumah dari daftar ATAU isi alamat rumah!");
        return;
      }
      
      // val foto identitas wajib diunggah
      if (_formData['fotoIdentitas'] == null || _formData['fotoIdentitas'].isEmpty) {
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
          _formData['statusRumah'] != null) {
        
        // konfir password
        if (_formData['password'] != _formData['konfirmasiPassword']) {
          ToastService.showError(context, "Password dan konfirmasi password tidak sama!");
          return;
        }

        // proses registrasi
        setState(() {
          // TODO: loading state jika perlu
        });

        await Future.delayed(const Duration(milliseconds: 1000));

        ToastService.showSuccess(context, "Pendaftaran berhasil!");
        
        // reset form setelah berhasil
        _resetForm();
        
        // print data untuk testing
        print('Data Pendaftaran: $_formData');
      } else {
        ToastService.showError(context, "Harap lengkapi semua field yang wajib diisi!");
      }
    }
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(
              child: Text(
                "Daftar Akun",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Lengkapi formulir untuk membuat akun",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),

            NamaLengkapField(
              onSaved: (value) => _formData['namaLengkap'] = value,
            ),
            const SizedBox(height: 16),
            NikField(
              onSaved: (value) => _formData['nik'] = value,
            ),
            const SizedBox(height: 16),
            EmailField(
              onSaved: (value) => _formData['email'] = value,
            ),
            const SizedBox(height: 16),
            TeleponField(
              onSaved: (value) => _formData['telepon'] = value,
            ),
            const SizedBox(height: 16),
            PasswordField(
              onSaved: (value) => _formData['password'] = value,
            ),
            const SizedBox(height: 16),
            KonfirmasiPasswordField(
              onSaved: (value) => _formData['konfirmasiPassword'] = value,
            ),
            const SizedBox(height: 16),

            JenisKelaminField(
              key: _jenisKelaminKey,
              onSaved: (value) => _formData['jenisKelamin'] = value,
            ),
            const SizedBox(height: 16),
            RumahField(
              key: _rumahKey,
              onSaved: (value) => _formData['rumah'] = value,
            ),
            const SizedBox(height: 16),
            AlamatRumahField(
              onSaved: (value) => _formData['alamatRumah'] = value,
            ),
            const SizedBox(height: 16),
            StatusRumahField(
              key: _statusRumahKey,
              onSaved: (value) => _formData['statusRumah'] = value,
            ),
            const SizedBox(height: 16),
            UploadIdentitasField(
              key: _uploadIdentitasKey,
              onSaved: (value) => _formData['fotoIdentitas'] = value,
            ),
            const SizedBox(height: 24),
          
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Buat Akun",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}