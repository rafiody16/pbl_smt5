import 'package:flutter/material.dart';
import '../../blocs/keluarga_bloc.dart';
import '../../models/keluarga_model.dart';

class KeluargaStreamForm extends StatefulWidget {
  final KeluargaBloc bloc;
  final KeluargaModel? existingKeluarga;

  const KeluargaStreamForm({
    Key? key,
    required this.bloc,
    this.existingKeluarga,
  }) : super(key: key);

  @override
  State<KeluargaStreamForm> createState() => _KeluargaStreamFormState();
}

class _KeluargaStreamFormState extends State<KeluargaStreamForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kepalaController = TextEditingController();
  final _anggotaController = TextEditingController();

  String _status = 'Aktif';
  int? _selectedRumahId;
  List<Map<String, dynamic>> _daftarRumah = [];
  bool _isLoadingRumah = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadDaftarRumah();
    if (widget.existingKeluarga != null) {
      final k = widget.existingKeluarga!;
      _namaController.text = k.namaKeluarga;
      _kepalaController.text = k.kepalaKeluarga ?? '';
      _anggotaController.text = k.jumlahAnggota?.toString() ?? '';
      _status = k.status;
      _selectedRumahId = k.rumahId;
    }
  }

  // Load data rumah untuk Dropdown
  Future<void> _loadDaftarRumah() async {
    final data = await widget.bloc.getDaftarRumah();
    if (mounted) {
      setState(() {
        _daftarRumah = data;
        _isLoadingRumah = false;
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kepalaController.dispose();
    _anggotaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final keluarga = KeluargaModel(
        namaKeluarga: _namaController.text,
        kepalaKeluarga: _kepalaController.text,
        jumlahAnggota: int.tryParse(_anggotaController.text),
        status: _status,
        rumahId: _selectedRumahId,
      );

      if (widget.existingKeluarga != null) {
        await widget.bloc.updateKeluarga(
          widget.existingKeluarga!.id!,
          keluarga,
        );
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil update keluarga')),
          );
      } else {
        await widget.bloc.addKeluarga(keluarga);
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil tambah keluarga')),
          );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.existingKeluarga != null ? 'Edit Keluarga' : 'Tambah Keluarga',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Informasi Keluarga'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: _inputDecoration(
                  'Nama Keluarga (KK)',
                  Icons.family_restroom,
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kepalaController,
                decoration: _inputDecoration('Kepala Keluarga', Icons.person),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Lokasi & Status'),
              const SizedBox(height: 16),

              // Dropdown Rumah
              _isLoadingRumah
                  ? const Center(child: LinearProgressIndicator())
                  : DropdownButtonFormField<int>(
                      value: _selectedRumahId,
                      isExpanded: true,
                      decoration: _inputDecoration('Lokasi Rumah', Icons.home),
                      items: _daftarRumah.map((rumah) {
                        return DropdownMenuItem<int>(
                          value: rumah['id'],
                          child: Text(
                            "${rumah['alamat']} (RT ${rumah['rt']})",
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedRumahId = val),
                      hint: const Text('Pilih Rumah'),
                    ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: _inputDecoration('Status', Icons.flag),
                items: ['Aktif', 'Pindah', 'Non-Aktif']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _anggotaController,
                decoration: _inputDecoration('Jumlah Anggota', Icons.group),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
