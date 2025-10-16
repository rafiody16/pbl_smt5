import 'package:flutter/material.dart';

class NamaLengkapField extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const NamaLengkapField({
    super.key,
    this.onSaved,
    this.validator,
  });

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama lengkap harus diisi';
    }
    if (value.length < 3) {
      return 'Nama lengkap minimal 3 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Nama Lengkap"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Masukkan nama lengkap",
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
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          onSaved: onSaved,
          validator: validator ?? _defaultValidator,
        ),
      ],
    );
  }
}