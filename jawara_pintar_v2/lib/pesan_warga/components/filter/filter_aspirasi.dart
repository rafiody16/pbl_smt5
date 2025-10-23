import 'package:flutter/material.dart';
import '../../../data/data_aspirasi.dart';
import 'filter_header.dart';
import 'filter_button.dart';

class FilterAspirasiDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterAspirasiDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterAspirasiDialog> createState() => _FilterAspirasiDialogState();
}

class _FilterAspirasiDialogState extends State<FilterAspirasiDialog> {
  final _formKey = GlobalKey<FormState>();

  String _selectedJudul = '';
  String? _selectedStatus;

  // Hitung berapa filter yang aktif
  int get _selectedCount {
    int count = 0;
    if (_selectedJudul.isNotEmpty) count++;
    if (_selectedStatus != null && _selectedStatus!.isNotEmpty) count++;
    return count;
  }

  void _applyFilter() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final filters = <String, String>{};
      if (_selectedJudul.isNotEmpty) filters['judul'] = _selectedJudul;
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
      _selectedJudul = '';
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
              // 🟦 Header dengan selectedCount
              FilterHeader(
                onClose: () => Navigator.of(context).pop(),
                selectedCount: _selectedCount,
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildFormFields(),
              const SizedBox(height: 24),

              // 🟦 Buttons dengan selectedCount juga
              FilterButtons(
                onReset: _resetFilter,
                onApply: _applyFilter,
                selectedCount: _selectedCount,
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
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Judul Aspirasi',
            hintText: 'Contoh: Perbaikan Jalan',
          ),
          onChanged: (value) => setState(() => _selectedJudul = value),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Status Aspirasi',
            hintText: '-- Pilih Status --',
          ),
          value: _selectedStatus,
          items: DataAspirasi.StatusAspirasi.map((status) {
            return DropdownMenuItem(value: status, child: Text(status));
          }).toList(),
          onChanged: (value) => setState(() => _selectedStatus = value),
        ),
      ],
    );
  }
}
