import 'package:flutter/material.dart';

class NamaLengkapField extends StatelessWidget {
  final String initialValue;
  final Function(String) onSaved;

  const NamaLengkapField({
    super.key,
    required this.initialValue,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Lengkap',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            cursorColor: Colors.blue,
            initialValue: initialValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onSaved: (value) => onSaved(value ?? ''),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama Lengkap tidak boleh kosong';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}