import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/data_broadcast.dart';
import 'filter_header.dart';
import 'filter_button.dart';

class FilterBroadcastDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterBroadcastDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterBroadcastDialog> createState() => _FilterBroadcastDialogState();
}

class _FilterBroadcastDialogState extends State<FilterBroadcastDialog> {
  final _formKey = GlobalKey<FormState>();

  String _selectedJudul = '';
  String? _selectedTanggal;

  int get _selectedCount {
    int count = 0;
    if (_selectedJudul.isNotEmpty) count++;
    if (_selectedTanggal != null && _selectedTanggal!.isNotEmpty) count++;
    return count;
  }

  void _applyFilter() {
    final filters = <String, String>{};
    if (_selectedJudul.isNotEmpty) filters['judul'] = _selectedJudul;
    if (_selectedTanggal != null && _selectedTanggal!.isNotEmpty) {
      filters['tanggal_publikasi'] = _selectedTanggal!;
    }

    widget.onFilterApplied(filters);
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedJudul = '';
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
    return FractionallySizedBox(
      heightFactor: null, // tinggi menyesuaikan isi
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // tinggi ikut isi (mini)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                FilterHeader(
                  onClose: () => Navigator.of(context).pop(),
                  selectedCount: _selectedCount,
                ),
                const Divider(height: 24),
                _buildFormFields(),
                const SizedBox(height: 16),
                FilterButtons(
                  onReset: _resetFilter,
                  onApply: _applyFilter,
                  selectedCount: _selectedCount,
                ),
              ],
            ),
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
            labelText: 'Judul Broadcast',
            hintText: 'Contoh: Pengumuman',
          ),
          onChanged: (value) => setState(() => _selectedJudul = value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Tanggal Publikasi',
            hintText: 'Pilih tanggal publikasi',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: _selectDate,
            ),
          ),
          controller: TextEditingController(text: _selectedTanggal ?? ''),
        ),
      ],
    );
  }
}
