import 'package:flutter/material.dart';
import '../../services/keluarga_service.dart';

class KeluargaField extends StatefulWidget {
  final void Function(int?)? onSaved;
  final String? Function(int?)? validator;
  final int? value;

  const KeluargaField({super.key, this.onSaved, this.validator, this.value});

  @override
  State<KeluargaField> createState() => _KeluargaFieldState();
}

class _KeluargaFieldState extends State<KeluargaField> {
  final _service = KeluargaService();
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.value;
  }

  void resetState() {
    setState(() {
      _selectedId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _service.getKeluarga(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingDropdown(label: 'Keluarga');
        }
        if (snapshot.hasError) {
          return _ErrorDropdown(
            label: 'Keluarga',
            message: '${snapshot.error}',
          );
        }
        final data = snapshot.data ?? [];
        final items = data
            .map(
              (row) => DropdownMenuItem<int>(
                value: row['id'] as int,
                child: Text(row['nama_keluarga']?.toString() ?? 'Tanpa nama'),
              ),
            )
            .toList();

        return DropdownButtonFormField<int>(
          value: _selectedId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Keluarga',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          hint: const Text('Pilih keluarga'),
          items: items,
          onChanged: (val) {
            setState(() => _selectedId = val);
          },
          onSaved: widget.onSaved,
          validator: widget.validator,
        );
      },
    );
  }
}

class _LoadingDropdown extends StatelessWidget {
  final String label;
  const _LoadingDropdown({required this.label});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: '$label (memuat...)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: const [],
      onChanged: null,
    );
  }
}

class _ErrorDropdown extends StatelessWidget {
  final String label;
  final String message;
  const _ErrorDropdown({required this.label, required this.message});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: '$label (gagal memuat)',
        helperText: message,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: const [],
      onChanged: null,
    );
  }
}
