import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const EmailField({
    super.key,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Email"),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Masukkan email disini",
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
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onSaved: onSaved,
          validator: validator,
        ),
      ],
    );
  }
}