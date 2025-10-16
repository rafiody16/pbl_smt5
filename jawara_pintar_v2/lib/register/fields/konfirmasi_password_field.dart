import 'package:flutter/material.dart';

class KonfirmasiPasswordField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const KonfirmasiPasswordField({
    super.key,
    this.onSaved,
    this.validator,
  });

  @override
  State<KonfirmasiPasswordField> createState() => _KonfirmasiPasswordFieldState();
}

class _KonfirmasiPasswordFieldState extends State<KonfirmasiPasswordField> {
  bool _obscureText = true;

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password harus diisi';
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
          child: Text("Konfirmasi Password"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: "Masukkan ulang password",
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
                _obscureText ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          onSaved: widget.onSaved,
          validator: widget.validator ?? _defaultValidator,
        ),
      ],
    );
  }
}