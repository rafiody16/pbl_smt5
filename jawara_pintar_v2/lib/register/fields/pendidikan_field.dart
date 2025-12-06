import 'package:flutter/material.dart';

class PendidikanField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? value;

  const PendidikanField({super.key, this.onSaved, this.value});

  @override
  State<PendidikanField> createState() => _PendidikanFieldState();
}

class _PendidikanFieldState extends State<PendidikanField> {
  String? _selectedPendidikan;

  @override
  void initState() {
    super.initState();
    _selectedPendidikan = widget.value;
  }

  void resetState() {
    setState(() {
      _selectedPendidikan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Pendidikan Terakhir",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.school),
      ),
      value: _selectedPendidikan,
      items: const [
        DropdownMenuItem(value: "Tidak Sekolah", child: Text("Tidak Sekolah")),
        DropdownMenuItem(value: "SD", child: Text("SD")),
        DropdownMenuItem(value: "SMP", child: Text("SMP")),
        DropdownMenuItem(value: "SMA", child: Text("SMA/SMK")),
        DropdownMenuItem(value: "D1", child: Text("D1")),
        DropdownMenuItem(value: "D2", child: Text("D2")),
        DropdownMenuItem(value: "D3", child: Text("D3")),
        DropdownMenuItem(value: "S1", child: Text("S1")),
        DropdownMenuItem(value: "S2", child: Text("S2")),
        DropdownMenuItem(value: "S3", child: Text("S3")),
      ],
      onChanged: (value) {
        setState(() {
          _selectedPendidikan = value;
        });
      },
      onSaved: widget.onSaved,
    );
  }
}
