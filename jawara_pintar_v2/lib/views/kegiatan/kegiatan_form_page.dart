import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/kegiatan_provider.dart';
import '../../models/kegiatan.dart';
import '../../services/toast_service.dart';

class KegiatanFormPage extends StatefulWidget {
  final Kegiatan? existing;
  const KegiatanFormPage({super.key, this.existing});

  @override
  State<KegiatanFormPage> createState() => _KegiatanFormPageState();
}

class _KegiatanFormPageState extends State<KegiatanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  String _nama = '';
  String? _kategori;
  String? _lokasi;
  String? _deskripsi;
  String? _penanggungJawab;
  DateTime? _tanggal;

  @override
  void initState() {
    super.initState();
    final k = widget.existing;
    if (k != null) {
      _nama = k.namaKegiatan;
      _kategori = k.kategori;
      _lokasi = k.lokasi;
      _deskripsi = k.deskripsi;
      _penanggungJawab = k.penanggungJawab;
      _tanggal = k.tanggalPelaksanaan;
      if (_tanggal != null) {
        _dateController.text = DateFormat('yyyy-MM-dd').format(_tanggal!);
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggal = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final provider = context.read<KegiatanProvider>();

    final kegiatan = Kegiatan(
      id: widget.existing?.id,
      namaKegiatan: _nama,
      kategori: _kategori,
      deskripsi: _deskripsi,
      lokasi: _lokasi,
      tanggalPelaksanaan: _tanggal,
      penanggungJawab: _penanggungJawab,
    );

    try {
      if (widget.existing == null) {
        await provider.add(kegiatan);
      } else {
        await provider.update(widget.existing!.id!, kegiatan);
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) ToastService.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kegiatan' : 'Tambah Kegiatan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: _nama,
                    decoration: const InputDecoration(
                      labelText: 'Nama Kegiatan',
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                    onSaved: (v) => _nama = v!.trim(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    value: _kategori,
                    items:
                        const [
                              'Komunitas & Sosial',
                              'Kebersihan & Keamanan',
                              'Keagamaan',
                              'Pendidikan',
                              'Kesehatan & Olahraga',
                              'Lainnya',
                            ]
                            .map(
                              (k) => DropdownMenuItem(value: k, child: Text(k)),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => _kategori = v),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Pilih kategori' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Pelaksanaan',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: _pickDate,
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Tanggal wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _lokasi,
                    decoration: const InputDecoration(labelText: 'Lokasi'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Lokasi wajib diisi' : null,
                    onSaved: (v) => _lokasi = v?.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _penanggungJawab,
                    decoration: const InputDecoration(
                      labelText: 'Penanggung Jawab',
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Penanggung jawab wajib diisi'
                        : null,
                    onSaved: (v) => _penanggungJawab = v?.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _deskripsi,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    onSaved: (v) => _deskripsi = v?.trim(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(isEdit ? 'Simpan' : 'Tambah'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
