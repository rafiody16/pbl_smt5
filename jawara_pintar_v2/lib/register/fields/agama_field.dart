import 'package:flutter/material.dart';

class AgamaField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? value;

  const AgamaField({super.key, this.onSaved, this.value});

  @override
  State<AgamaField> createState() => _AgamaFieldState();
}

class _AgamaFieldState extends State<AgamaField> {
  String? _selectedAgama;

  @override
  void initState() {
    super.initState();
    _selectedAgama = widget.value;
  }

  void resetState() {
    setState(() {
      _selectedAgama = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Agama",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.mosque),
      ),
      value: _selectedAgama,
      items: const [
        DropdownMenuItem(value: "Islam", child: Text("Islam")),
        DropdownMenuItem(value: "Kristen", child: Text("Kristen")),
        DropdownMenuItem(value: "Katolik", child: Text("Katolik")),
        DropdownMenuItem(value: "Hindu", child: Text("Hindu")),
        DropdownMenuItem(value: "Buddha", child: Text("Buddha")),
        DropdownMenuItem(value: "Konghucu", child: Text("Konghucu")),
      ],
      onChanged: (value) {
        setState(() {
          _selectedAgama = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Agama wajib dipilih";
        }
        return null;
      },
      onSaved: widget.onSaved,
    );
  }
}
