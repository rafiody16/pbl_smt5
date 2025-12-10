import 'package:flutter/material.dart';
import '../../blocs/rumah_bloc.dart';
import '../../models/rumah.dart';

class RumahStreamForm extends StatefulWidget {
  final RumahBloc bloc;
  final Rumah? existingRumah;

  const RumahStreamForm({Key? key, required this.bloc, this.existingRumah})
    : super(key: key);

  @override
  State<RumahStreamForm> createState() => _RumahStreamFormState();
}

class _RumahStreamFormState extends State<RumahStreamForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _alamatController = TextEditingController();
  final _rtController = TextEditingController(text: '001');
  final _rwController = TextEditingController(text: '001');
  final _penghuniController = TextEditingController();
  final _luasTanahController = TextEditingController();
  final _luasBangunanController = TextEditingController();

  // Dropdown Values
  String _statusRumah = 'Tersedia';
  String? _statusKepemilikan;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingRumah != null) {
      final r = widget.existingRumah!;
      _alamatController.text = r.alamat;
      _rtController.text = r.rt;
      _rwController.text = r.rw;
      _penghuniController.text = r.jumlahPenghuni?.toString() ?? '';
      _luasTanahController.text = r.luasTanah?.toString() ?? '';
      _luasBangunanController.text = r.luasBangunan?.toString() ?? '';
      _statusRumah = r.statusRumah;
      _statusKepemilikan = r.statusKepemilikan;
    }
  }

  @override
  void dispose() {
    _alamatController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _penghuniController.dispose();
    _luasTanahController.dispose();
    _luasBangunanController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final rumah = Rumah(
        alamat: _alamatController.text,
        rt: _rtController.text,
        rw: _rwController.text,
        jumlahPenghuni: int.tryParse(_penghuniController.text),
        statusRumah: _statusRumah,
        statusKepemilikan: _statusKepemilikan,
        luasTanah: int.tryParse(_luasTanahController.text),
        luasBangunan: int.tryParse(_luasBangunanController.text),
      );

      if (widget.existingRumah != null) {
        // Mode Edit
        await widget.bloc.updateRumah(widget.existingRumah!.id!, rumah);
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil memperbarui data rumah')),
          );
      } else {
        // Mode Tambah
        await widget.bloc.addRumah(rumah);
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil menambah data rumah')),
          );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.existingRumah != null ? 'Edit Rumah' : 'Tambah Rumah',
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
              _buildSectionTitle('Informasi Dasar'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _alamatController,
                decoration: _inputDecoration(
                  'Alamat Lengkap',
                  Icons.location_on,
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rtController,
                      decoration: _inputDecoration('RT', Icons.numbers),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _rwController,
                      decoration: _inputDecoration('RW', Icons.numbers),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Status & Fisik'),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _statusRumah,
                decoration: _inputDecoration('Status Hunian', Icons.home_work),
                items: ['Tersedia', 'Ditempati']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _statusRumah = val!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _statusKepemilikan,
                decoration: _inputDecoration('Status Kepemilikan', Icons.key),
                items: ['Milik Sendiri', 'Sewa', 'Dinas']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _statusKepemilikan = val),
                validator: (v) => v == null ? 'Pilih status' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _penghuniController,
                decoration: _inputDecoration('Jumlah Penghuni', Icons.people),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _luasTanahController,
                      decoration: _inputDecoration(
                        'Luas Tanah (m²)',
                        Icons.landscape,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _luasBangunanController,
                      decoration: _inputDecoration(
                        'Luas Bangunan (m²)',
                        Icons.house,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
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
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
