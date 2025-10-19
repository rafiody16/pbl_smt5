import 'package:flutter/material.dart';
import 'fields/nama_field.dart';
import 'fields/jenis_kelamin_field.dart';
import 'fields/status_field.dart';
import 'filter_header.dart';
import 'filter_buttons.dart';

class FilterPenerimaanWargaDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterPenerimaanWargaDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterPenerimaanWargaDialog> createState() => _FilterPenerimaanWargaDialogState();
}

class _FilterPenerimaanWargaDialogState extends State<FilterPenerimaanWargaDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedNama = '';
  String? _selectedJenisKelamin;
  String? _selectedStatus;

  void _applyFilter() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final filters = <String, String>{};
      if (_selectedNama.isNotEmpty) filters['nama'] = _selectedNama;
      if (_selectedJenisKelamin != null && _selectedJenisKelamin!.isNotEmpty) {
        filters['jenis_kelamin'] = _selectedJenisKelamin!;
      }
      if (_selectedStatus != null && _selectedStatus!.isNotEmpty) {
        filters['status'] = _selectedStatus!;
      }

      widget.onFilterApplied(filters);
      Navigator.of(context).pop();
    }
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedNama = '';
      _selectedJenisKelamin = null;
      _selectedStatus = null;
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
              const FilterHeaderPenerimaan(),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildFormFields(),
              const SizedBox(height: 24),
              FilterButtonsPenerimaan(
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
        NamaField(
          onChanged: (value) => setState(() => _selectedNama = value),
        ),
        const SizedBox(height: 16),
        JenisKelaminField(
          selectedValue: _selectedJenisKelamin,
          onChanged: (value) => setState(() => _selectedJenisKelamin = value),
        ),
        const SizedBox(height: 16),
        StatusPenerimaanField(
          selectedValue: _selectedStatus,
          onChanged: (value) => setState(() => _selectedStatus = value),
        ),
      ],
    );
  }
}