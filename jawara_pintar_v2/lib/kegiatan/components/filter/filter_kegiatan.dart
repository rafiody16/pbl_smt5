import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/kegiatan_data.dart';
import 'filter_header.dart';
import 'filter_button.dart';

class FilterKegiatanDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterKegiatanDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterKegiatanDialog> createState() => _FilterKegiatanDialogState();
}

class _FilterKegiatanDialogState extends State<FilterKegiatanDialog> {
  final _formKey = GlobalKey<FormState>();

  String _selectedNama = '';
  String? _selectedKategori;
  String? _selectedTanggal;
  String? _selectedPenanggungJawab;

  int get _selectedCount {
    int count = 0;
    if (_selectedNama.isNotEmpty) count++;
    if (_selectedKategori != null && _selectedKategori!.isNotEmpty) count++;
    if (_selectedTanggal != null && _selectedTanggal!.isNotEmpty) count++;
    if (_selectedPenanggungJawab != null &&
        _selectedPenanggungJawab!.isNotEmpty)
      count++;
    return count;
  }

  void _applyFilter() {
    final filters = <String, String>{};
    if (_selectedNama.isNotEmpty) filters['nama'] = _selectedNama;
    if (_selectedKategori != null && _selectedKategori!.isNotEmpty) {
      filters['kategori'] = _selectedKategori!;
    }
    if (_selectedTanggal != null && _selectedTanggal!.isNotEmpty) {
      filters['tanggal'] = _selectedTanggal!;
    }
    if (_selectedPenanggungJawab != null &&
        _selectedPenanggungJawab!.isNotEmpty) {
      filters['penanggungJawab'] = _selectedPenanggungJawab!;
    }

    widget.onFilterApplied(filters);
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedNama = '';
      _selectedKategori = null;
      _selectedTanggal = null;
      _selectedPenanggungJawab = null;
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
        // Nama kegiatan
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Nama Kegiatan',
            hintText: 'Contoh: Donor Darah Bersama PMI',
          ),
          onChanged: (value) => setState(() => _selectedNama = value),
        ),
        const SizedBox(height: 16),

        // Kategori kegiatan
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Kategori Kegiatan',
            hintText: '-- Pilih Kategori --',
          ),
          value: _selectedKategori,
          items: KegiatanData.kategoriKegiatan.map((kategori) {
            return DropdownMenuItem(value: kategori, child: Text(kategori));
          }).toList(),
          onChanged: (value) => setState(() => _selectedKategori = value),
        ),
        const SizedBox(height: 16),

        // Tanggal pelaksanaan
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Tanggal Pelaksanaan',
            hintText: 'Pilih tanggal kegiatan',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: _selectDate,
            ),
          ),
          controller: TextEditingController(text: _selectedTanggal ?? ''),
        ),
        const SizedBox(height: 16),

        // Penanggung jawab
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Penanggung Jawab',
            hintText: 'Contoh: Pak Dedi, Bu Lina...',
          ),
          onChanged: (value) =>
              setState(() => _selectedPenanggungJawab = value),
        ),
      ],
    );
  }
}
