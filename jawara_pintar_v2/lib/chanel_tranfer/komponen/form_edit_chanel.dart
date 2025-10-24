import 'package:flutter/material.dart';
import '../../../model/chanel_transfer.dart';

class FormEditChanel extends StatefulWidget {
  final ChanelTransfer chanel;
  const FormEditChanel({super.key, required this.chanel});

  @override
  State<FormEditChanel> createState() => _FormEditChanelState();
}

class _FormEditChanelState extends State<FormEditChanel> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaChanelController;
  late TextEditingController _nomorRekeningController;
  late TextEditingController _namaPemilikController;
  late TextEditingController _catatanController;
  String? _selectedTipe;

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data yang ada
    _namaChanelController = TextEditingController(text: widget.chanel.nama);
    _nomorRekeningController = TextEditingController(text: widget.chanel.nomorAkun);
    _namaPemilikController = TextEditingController(text: widget.chanel.namaPemilik);
    _catatanController = TextEditingController(text: widget.chanel.catatan);
    _selectedTipe = widget.chanel.tipe;
  }

  @override
  void dispose() {
    _namaChanelController.dispose();
    _nomorRekeningController.dispose();
    _namaPemilikController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan berhasil disimpan! (Simulasi)')),
      );
      Navigator.pop(context); // Kembali ke halaman daftar
    }
  }

  Widget _buildFileUploadField(String label, String hint) {
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
              hint,
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
              TextFormField(
                controller: _namaChanelController,
                decoration: const InputDecoration(labelText: 'Nama Chanel'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTipe,
                decoration: const InputDecoration(labelText: 'Tipe'),
                items: ['Bank', 'E-Wallet', 'qris', 'ewallet', 'bank']
                    .toSet() // Hindari duplikat
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTipe = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Tipe harus dipilih' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomorRekeningController,
                decoration: const InputDecoration(labelText: 'Nomor Rekening / Akun'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nomor tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _namaPemilikController,
                decoration: const InputDecoration(labelText: 'Nama Pemilik'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama pemilik tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              _buildFileUploadField('Ganti QR', 'Upload QR baru jika ingin mengganti'),
              const SizedBox(height: 20),
              _buildFileUploadField('Ganti Thumbnail', 'Upload thumbnail baru jika ingin mengganti'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _catatanController,
                decoration: const InputDecoration(labelText: 'Catatan (Opsional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveForm,
                    child: const Text('Simpan'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
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