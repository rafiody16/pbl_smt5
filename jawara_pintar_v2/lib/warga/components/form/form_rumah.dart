import 'package:flutter/material.dart';
import 'fields/alamat_rumah_field.dart';
import 'fields/status_rumah_field.dart';

class FormRumah extends StatelessWidget {
  final Map<String, dynamic> initialData;
  final GlobalKey<FormState> formKey;
  final Function(String) onAlamatChanged;
  final Function(String) onStatusChanged;

  const FormRumah({
    super.key,
    required this.initialData,
    required this.formKey,
    required this.onAlamatChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AlamatRumahField(
            initialValue: initialData['alamat'] ?? '',
            onSaved: (value) => onAlamatChanged(value),
          ),
          StatusRumahField(
            value: initialData['status'] ?? 'Tersedia',
            onChanged: (value) => onStatusChanged(value),
          ),
        ],
      ),
    );
  }
}