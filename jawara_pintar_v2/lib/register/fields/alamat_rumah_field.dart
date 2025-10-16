import 'package:flutter/material.dart';

class AlamatRumahField extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const AlamatRumahField({
    super.key,
    this.onSaved,
    this.validator,
  });

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat rumah harus diisi jika tidak memilih dari daftar';
    }
    if (value.length < 5) {
      return 'Alamat rumah minimal 5 karakter';
    }
    if (value.length > 100) {
      return 'Alamat rumah maksimal 100 karakter';
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
          child: Text("Alamat Rumah (Jika Tidak Ada di List)"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLength: 100,
          decoration: InputDecoration(
            hintText: "Blok 5A / No.10",
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
            counterText: '',
          ),
          onSaved: onSaved,
          validator: validator ?? _defaultValidator,
        ),
      ],
    );
  }
}