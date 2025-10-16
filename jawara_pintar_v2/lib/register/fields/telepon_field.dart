import 'package:flutter/material.dart';

class TeleponField extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const TeleponField({
    super.key,
    this.onSaved,
    this.validator,
  });

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'No telepon harus diisi';
    }
    if (!value.startsWith('08')) {
      return 'No telepon harus dimulai dengan 08';
    }
    if (value.length < 10 || value.length > 13) {
      return 'No telepon harus 10-13 digit';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'No telepon hanya boleh mengandung angka';
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
          child: Text("No Telepon"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "08xxxxxxxxx",
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