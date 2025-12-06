import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/toast_service.dart';
import 'email_field.dart';
import 'password_field.dart';
import '../providers/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final authProvider = context.read<AuthProvider>();

      final success = await authProvider.login(_email, _password);

      if (mounted) {
        if (success) {
          ToastService.showSuccess(context, "Login berhasil!");
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          ToastService.showError(
            context,
            authProvider.errorMessage ?? 'Login gagal',
          );
        }
      }
      /*await Future.delayed(const Duration(milliseconds: 500));

      if (LoginData.validateCredentials(_email, _password)) {
        ToastService.showSuccess(context, "Login berhasil!");

        await Future.delayed(const Duration(milliseconds: 1500));
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        }
      } else {
        ToastService.showError(context, "Email atau password salah!");
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }*/
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
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
                "Masuk ke akun anda",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // email field
            EmailField(
              onSaved: (value) => _email = value ?? '',
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),

            // password field
            PasswordField(
              onSaved: (value) => _password = value ?? '',
              validator: _validatePassword,
              obscureText: _obscurePassword,
              onToggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            const SizedBox(height: 24),

            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _login,
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
                        : const Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
