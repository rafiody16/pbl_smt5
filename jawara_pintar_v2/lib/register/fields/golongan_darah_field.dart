import 'package:flutter/material.dart';

class GolonganDarahField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? value;

  const GolonganDarahField({super.key, this.onSaved, this.value});

  @override
  State<GolonganDarahField> createState() => _GolonganDarahFieldState();
}

class _GolonganDarahFieldState extends State<GolonganDarahField> {
  String? _selectedGolonganDarah;

  @override
  void initState() {
    super.initState();
    _selectedGolonganDarah = widget.value;
  }

  void resetState() {
    setState(() {
      _selectedGolonganDarah = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Golongan Darah",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.bloodtype),
      ),
      value: _selectedGolonganDarah,
      items: const [
        DropdownMenuItem(value: "A", child: Text("A")),
        DropdownMenuItem(value: "B", child: Text("B")),
        DropdownMenuItem(value: "AB", child: Text("AB")),
        DropdownMenuItem(value: "O", child: Text("O")),
      ],
      onChanged: (value) {
        setState(() {
          _selectedGolonganDarah = value;
        });
      },
      onSaved: widget.onSaved,
    );
  }
}
