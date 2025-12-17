import 'package:flutter/material.dart';

class RoleSistemField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? value;

  const RoleSistemField({super.key, this.onSaved, this.value});

  @override
  State<RoleSistemField> createState() => _RoleSistemFieldState();
}

class _RoleSistemFieldState extends State<RoleSistemField> {
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.value ?? 'warga';
  }

  void resetState() {
    setState(() {
      _selectedRole = 'warga';
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Role Sistem",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.admin_panel_settings),
        helperText: "Hak akses pengguna dalam sistem",
      ),
      value: _selectedRole,
      items: const [
        DropdownMenuItem(value: "admin", child: Text("Admin")),
        DropdownMenuItem(value: "bendahara", child: Text("Bendahara")),
        DropdownMenuItem(value: "sekretaris", child: Text("Sekretaris")),
        DropdownMenuItem(value: "ketua_rt", child: Text("Ketua RT")),
        DropdownMenuItem(value: "ketua_rw", child: Text("Ketua RW")),
        DropdownMenuItem(value: "warga", child: Text("Warga")),
      ],
      onChanged: (value) {
        setState(() {
          _selectedRole = value;
        });
      },
      onSaved: widget.onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Role sistem wajib dipilih';
        }
        return null;
      },
    );
  }
}
