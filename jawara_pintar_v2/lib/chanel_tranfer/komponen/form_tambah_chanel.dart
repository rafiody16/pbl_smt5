import 'package:flutter/material.dart';

class FormTambahChanel extends StatefulWidget {
  const FormTambahChanel({super.key});

  @override
  State<FormTambahChanel> createState() => _FormTambahChanelState();
}

class _FormTambahChanelState extends State<FormTambahChanel> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _namaChanelController = TextEditingController();
  final _nomorRekeningController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _catatanController = TextEditingController();

  // Nilai terpilih
  String? _selectedTipe;

  @override
  void dispose() {
    _namaChanelController.dispose();
    _nomorRekeningController.dispose();
    _namaPemilikController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaChanelController.clear();
    _nomorRekeningController.clear();
    _namaPemilikController.clear();
    _catatanController.clear();
    setState(() {
      _selectedTipe = null;
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Channel baru berhasil disimpan! (Simulasi)')),
      );
      _resetForm();
    }
  }

  // Widget placeholder untuk upload file
  Widget _buildFileUploadField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Center(
            child: Text(
              'Upload foto $label (jika ada) png/jpeg/jpg',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ),
      ],
    );
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
              // 1. Nama Channel
              TextFormField(
                controller: _namaChanelController,
                decoration: const InputDecoration(
                  labelText: 'Nama Channel',
                  hintText: 'Contoh: BCA, Dana, QRIS RT',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),

              // 2. Tipe
              DropdownButtonFormField<String>(
                value: _selectedTipe,
                decoration: const InputDecoration(
                  labelText: 'Tipe',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('-- Pilih Tipe --'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTipe = newValue;
                  });
                },
                items: <String>['Bank', 'E-Wallet', 'QRIS']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Tipe harus dipilih' : null,
              ),
              const SizedBox(height: 20),

              // 3. Nomor Rekening / Akun
              TextFormField(
                controller: _nomorRekeningController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Rekening / Akun',
                  hintText: 'Contoh: 1234567890',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nomor tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),

              // 4. Nama Pemilik
              TextFormField(
                controller: _namaPemilikController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemilik',
                  hintText: 'Contoh: John Doe',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama pemilik tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),

              // 5. QR
              _buildFileUploadField('QR'),
              const SizedBox(height: 20),

              // 6. Thumbnail
              _buildFileUploadField('Thumbnail'),
              const SizedBox(height: 20),

              // 7. Catatan (Opsional)
              TextFormField(
                controller: _catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  hintText: 'Contoh: Transfer hanya dari bank yang sama...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // 8. Tombol
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