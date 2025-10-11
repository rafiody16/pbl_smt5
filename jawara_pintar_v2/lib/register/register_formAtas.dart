import 'package:flutter/material.dart';

class RegisterFormAtas extends StatelessWidget {
  const RegisterFormAtas({super.key});

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(label),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(label),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.visibility_off,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField("Nama Lengkap", "Masukkan nama lengkap"),
        const SizedBox(height: 16),

        _buildTextField("NIK", "Masukkan NIK sesuai KTP"),
        const SizedBox(height: 16),

        _buildTextField("Email", "Masukkan email aktif"),
        const SizedBox(height: 16),

        _buildTextField("No Telepon", "08xxxxxxxxx"),
        const SizedBox(height: 16),

        _buildPasswordField("Password", "Masukkan password"),
        const SizedBox(height: 16),

        _buildPasswordField("Konfirmasi Password", "Masukkan ulang password"),
      ],
    );
  }
}