import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/log_data.dart';
import 'filter_header.dart';
import 'filter_button.dart';

class FilterLogDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterLogDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterLogDialog> createState() => _FilterLogDialog();
}

class _FilterLogDialog extends State<FilterLogDialog> {
  final _formKey = GlobalKey<FormState>();

  String _selectedAktor = '';
  String _selectedDeskripsi = '';
  String? _selectedTanggal;

  void _applyFilter() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final filters = <String, String>{};
      if (_selectedAktor.isNotEmpty) filters['aktor'] = _selectedAktor;
      if (_selectedDeskripsi.isNotEmpty)
        filters['deskripsi'] = _selectedDeskripsi;
      if (_selectedTanggal != null)
        filters['tanggal_publikasi'] = _selectedTanggal!;

      widget.onFilterApplied(filters);
      Navigator.of(context).pop();
    }
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedAktor = '';
      _selectedDeskripsi = '';
      _selectedTanggal = null;
    });
    widget.onFilterReset();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id', 'ID'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedTanggal = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
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
              FilterButtons(onReset: _resetFilter, onApply: _applyFilter),
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
            labelText: 'Pelaku',
            hintText: 'Contoh: Anto',
          ),
          onChanged: (value) => setState(() => _selectedAktor = value),
        ),
        const SizedBox(height: 16),

        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Deskripsi',
            hintText: 'Contoh: Mengubah data warga',
          ),
          onChanged: (value) => setState(() => _selectedAktor = value),
        ),
        const SizedBox(height: 16),

        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Dari Tanggal',
            hintText: 'Pilih tanggal publikasi',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: _selectDate,
            ),
          ),
          controller: TextEditingController(text: _selectedTanggal ?? ''),
        ),
        const SizedBox(height: 16),

        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Sampai Tanggal',
            hintText: 'Pilih tanggal publikasi',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: _selectDate,
            ),
          ),
          controller: TextEditingController(text: _selectedTanggal ?? ''),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
