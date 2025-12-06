import 'package:flutter/material.dart';

class PekerjaanField extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? initialValue;

  const PekerjaanField({super.key, this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration(
        labelText: "Pekerjaan",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.work),
        hintText: "Contoh: Pegawai Swasta, Wiraswasta, dll",
      ),
      onSaved: onSaved,
    );
  }
}
