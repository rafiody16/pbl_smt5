import 'package:flutter/material.dart';

class PeranField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? value;

  const PeranField({super.key, this.onSaved, this.value});

  @override
  State<PeranField> createState() => _PeranFieldState();
}

class _PeranFieldState extends State<PeranField> {
  String? _selectedPeran;

  @override
  void initState() {
    super.initState();
    _selectedPeran = widget.value;
  }

  void resetState() {
    setState(() {
      _selectedPeran = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Peran dalam Keluarga",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.family_restroom),
      ),
      value: _selectedPeran,
      items: const [
        DropdownMenuItem(
          value: "Kepala Keluarga",
          child: Text("Kepala Keluarga"),
        ),
        DropdownMenuItem(value: "Istri", child: Text("Istri")),
        DropdownMenuItem(value: "Anak", child: Text("Anak")),
        DropdownMenuItem(
          value: "Anggota Keluarga",
          child: Text("Anggota Keluarga"),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedPeran = value;
        });
      },
      onSaved: widget.onSaved,
    );
  }
}
