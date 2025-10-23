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
  State<FilterLogDialog> createState() => _FilterLogDialogState();
}

class _FilterLogDialogState extends State<FilterLogDialog> {
  final _formKey = GlobalKey<FormState>();

  String _selectedAktor = '';
  String _selectedDeskripsi = '';
  String? _selectedDariTanggal;
  String? _selectedSampaiTanggal;

  int get _selectedCount {
    int count = 0;
    if (_selectedAktor.isNotEmpty) count++;
    if (_selectedDeskripsi.isNotEmpty) count++;
    if (_selectedDariTanggal != null && _selectedDariTanggal!.isNotEmpty)
      count++;
    if (_selectedSampaiTanggal != null && _selectedSampaiTanggal!.isNotEmpty)
      count++;
    return count;
  }

  void _applyFilter() {
    final filters = <String, String>{};
    if (_selectedAktor.isNotEmpty) filters['aktor'] = _selectedAktor;
    if (_selectedDeskripsi.isNotEmpty)
      filters['deskripsi'] = _selectedDeskripsi;
    if (_selectedDariTanggal != null && _selectedDariTanggal!.isNotEmpty) {
      filters['dari_tanggal'] = _selectedDariTanggal!;
    }
    if (_selectedSampaiTanggal != null && _selectedSampaiTanggal!.isNotEmpty) {
      filters['sampai_tanggal'] = _selectedSampaiTanggal!;
    }

    widget.onFilterApplied(filters);
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedAktor = '';
      _selectedDeskripsi = '';
      _selectedDariTanggal = null;
      _selectedSampaiTanggal = null;
    });
    widget.onFilterReset();
  }

  Future<void> _selectDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id', 'ID'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        final formatted = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
        if (isStart) {
          _selectedDariTanggal = formatted;
        } else {
          _selectedSampaiTanggal = formatted;
        }
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // garis kecil di atas modal
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
        // Pelaku
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Pelaku',
            hintText: 'Contoh: Anto',
          ),
          onChanged: (value) => setState(() => _selectedAktor = value),
        ),
        const SizedBox(height: 16),

        // Deskripsi
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Deskripsi',
            hintText: 'Contoh: Mengubah data warga',
          ),
          onChanged: (value) => setState(() => _selectedDeskripsi = value),
        ),
        const SizedBox(height: 16),

        // Dari tanggal
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Dari Tanggal',
            hintText: 'Pilih tanggal awal',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () => _selectDate(isStart: true),
            ),
          ),
          controller: TextEditingController(text: _selectedDariTanggal ?? ''),
        ),
        const SizedBox(height: 16),

        // Sampai tanggal
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Sampai Tanggal',
            hintText: 'Pilih tanggal akhir',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () => _selectDate(isStart: false),
            ),
          ),
          controller: TextEditingController(text: _selectedSampaiTanggal ?? ''),
        ),
      ],
    );
  }
}
