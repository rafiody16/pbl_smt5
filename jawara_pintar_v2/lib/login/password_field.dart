import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const PasswordField({
    super.key,
    this.onSaved,
    this.validator,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password"),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Masukkan password disini",
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
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          obscureText: obscureText,
          textInputAction: TextInputAction.done,
          onSaved: onSaved,
          validator: validator,
          onFieldSubmitted: (_) {
            // Handle login when password field is submitted
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    );
  }
}