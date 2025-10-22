import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl untuk format tanggal

class FormTambahMutasi extends StatefulWidget {
  const FormTambahMutasi({super.key});

  @override
  State<FormTambahMutasi> createState() => _FormTambahMutasiState();
}

class _FormTambahMutasiState extends State<FormTambahMutasi> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _alasanController = TextEditingController();
  final _tanggalController = TextEditingController();

  // Nilai terpilih
  String? _selectedJenisMutasi;
  String? _selectedKeluarga;

  @override
  void dispose() {
    _alasanController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Format tanggal seperti '15 Oktober 2025'
        _tanggalController.text = DateFormat('d MMMM yyyy').format(picked);
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _alasanController.clear();
    _tanggalController.clear();
    setState(() {
      _selectedJenisMutasi = null;
      _selectedKeluarga = null;
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mutasi baru berhasil disimpan! (Simulasi)')),
      );
      _resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dropdown Jenis Mutasi
              DropdownButtonFormField<String>(
                value: _selectedJenisMutasi,
                decoration: const InputDecoration(
                  labelText: 'Jenis Mutasi',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('-- Pilih Jenis Mutasi --'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJenisMutasi = newValue;
                  });
                },
                items: <String>['Pindah Rumah', 'Keluar Wilayah']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Jenis mutasi harus dipilih' : null,
              ),
              const SizedBox(height: 20),

              // 2. Dropdown Keluarga
              DropdownButtonFormField<String>(
                value: _selectedKeluarga,
                decoration: const InputDecoration(
                  labelText: 'Keluarga',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('-- Pilih Keluarga --'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKeluarga = newValue;
                  });
                },
                // Data ini bisa diambil dari UserData atau data keluarga nanti
                items: <String>[
                  'Keluarga Ijat',
                  'Keluarga Mara Nunez',
                  'Keluarga Budi'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Keluarga harus dipilih' : null,
              ),
              const SizedBox(height: 20),

              // 3. Text Area Alasan Mutasi
              TextFormField(
                controller: _alasanController,
                decoration: const InputDecoration(
                  labelText: 'Alasan Mutasi',
                  hintText: 'Masukkan alasan disini...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alasan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 4. Input Tanggal Mutasi (Date Picker)
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Mutasi',
                  hintText: '--/--/----',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true, // Mencegah keyboard muncul
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // 5. Tombol
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _saveForm,
                    child: const Text('Simpan'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _resetForm,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}