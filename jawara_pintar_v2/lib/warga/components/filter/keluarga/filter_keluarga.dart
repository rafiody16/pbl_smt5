import 'package:flutter/material.dart';
import 'fields/nama_keluarga_field.dart';
import 'fields/status_field.dart';
import 'fields/rumah_field.dart';
import 'filter_header.dart';
import 'filter_buttons.dart';

class FilterKeluargaDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterKeluargaDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterKeluargaDialog> createState() => _FilterKeluargaDialogState();
}

class _FilterKeluargaDialogState extends State<FilterKeluargaDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedNama = '';
  String? _selectedStatus;
  String? _selectedRumah;

  void _applyFilter() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final filters = <String, String>{};
      if (_selectedNama.isNotEmpty) filters['nama'] = _selectedNama;
      if (_selectedStatus != null) filters['status'] = _selectedStatus!;
      if (_selectedRumah != null) filters['rumah'] = _selectedRumah!;

      widget.onFilterApplied(filters);
      Navigator.of(context).pop();
    }
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedNama = '';
      _selectedStatus = null;
      _selectedRumah = null;
    });
    widget.onFilterReset();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterHeader(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildFormFields(),
              const SizedBox(height: 24),
              FilterButtons(
                onReset: _resetFilter,
                onApply: _applyFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Field Nama
        NamaKeluargaField(
          onChanged: (value) => setState(() => _selectedNama = value),
        ),
        const SizedBox(height: 16),
        
        // Field Status
        StatusField(
          selectedValue: _selectedStatus,
          onChanged: (value) => setState(() => _selectedStatus = value),
        ),
        const SizedBox(height: 16),
        
        // Field Rumah
        RumahField(
          selectedValue: _selectedRumah,
          onChanged: (value) => setState(() => _selectedRumah = value),
        ),
      ],
    );
  }
}