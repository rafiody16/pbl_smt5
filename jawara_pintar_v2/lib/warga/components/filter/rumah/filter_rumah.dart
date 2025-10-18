import 'package:flutter/material.dart';
import 'fields/alamat_field.dart';
import 'fields/status_field.dart';
import 'filter_header.dart';
import 'filter_buttons.dart';

class FilterRumahDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterRumahDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterRumahDialog> createState() => _FilterRumahDialogState();
}

class _FilterRumahDialogState extends State<FilterRumahDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedAlamat = '';
  String? _selectedStatus;

  void _applyFilter() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final filters = <String, String>{};
      if (_selectedAlamat.isNotEmpty) filters['alamat'] = _selectedAlamat;
      if (_selectedStatus != null && _selectedStatus!.isNotEmpty) filters['status'] = _selectedStatus!;

      widget.onFilterApplied(filters);
      Navigator.of(context).pop();
    }
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedAlamat = '';
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
              FilterHeaderRumah(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildFormFields(),
              const SizedBox(height: 24),
              FilterButtonsRumah(
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
        AlamatField(
          onChanged: (value) => setState(() => _selectedAlamat = value),
        ),
        const SizedBox(height: 16),

        StatusRumahField(
          selectedValue: _selectedStatus,
          onChanged: (value) => setState(() => _selectedStatus = value),
        ),
      ],
    );
  }
}