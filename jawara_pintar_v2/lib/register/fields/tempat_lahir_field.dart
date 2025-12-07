import 'package:flutter/material.dart';

class TempatLahirField extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? initialValue;

  const TempatLahirField({super.key, this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration(
        labelText: "Tempat Lahir",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_city),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Tempat lahir wajib diisi";
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
