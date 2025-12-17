import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/broadcast_provider.dart';
import '../../models/broadcast.dart';
import '../../services/toast_service.dart';

class BroadcastFormPage extends StatefulWidget {
  final Broadcast? existing;
  const BroadcastFormPage({super.key, this.existing});

  @override
  State<BroadcastFormPage> createState() => _BroadcastFormPageState();
}

class _BroadcastFormPageState extends State<BroadcastFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  String _judul = '';
  String? _isiPesan;
  String? _dibuatOleh;
  String? _lampiranGambar;
  String? _lampiranDokumen;
  DateTime? _tanggalPublikasi;

  @override
  void initState() {
    super.initState();
    final b = widget.existing;
    if (b != null) {
      _judul = b.judul;
      _isiPesan = b.isiPesan;
      _dibuatOleh = b.dibuatOleh;
      _lampiranGambar = b.lampiranGambar;
      _lampiranDokumen = b.lampiranDokumen;
      _tanggalPublikasi = b.tanggalPublikasi;
      if (_tanggalPublikasi != null) {
        _dateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(_tanggalPublikasi!);
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
      initialDate: _tanggalPublikasi ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalPublikasi = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final provider = context.read<BroadcastProvider>();

    final b = Broadcast(
      id: widget.existing?.id,
      judul: _judul,
      isiPesan: _isiPesan,
      tanggalPublikasi: _tanggalPublikasi,
      dibuatOleh: _dibuatOleh,
      lampiranGambar: _lampiranGambar,
      lampiranDokumen: _lampiranDokumen,
    );

    try {
      if (widget.existing == null) {
        await provider.add(b);
      } else {
        await provider.update(widget.existing!.id!, b);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ToastService.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Broadcast' : 'Tambah Broadcast'),
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
                    initialValue: _judul,
                    decoration: const InputDecoration(labelText: 'Judul'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                    onSaved: (v) => _judul = v!.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _isiPesan,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Isi Pesan'),
                    onSaved: (v) => _isiPesan = v?.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Publikasi',
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
                    initialValue: _dibuatOleh,
                    decoration: const InputDecoration(labelText: 'Dibuat Oleh'),
                    onSaved: (v) => _dibuatOleh = v?.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _lampiranGambar,
                    decoration: const InputDecoration(
                      labelText: 'Lampiran Gambar (opsional)',
                    ),
                    onSaved: (v) => _lampiranGambar = v?.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _lampiranDokumen,
                    decoration: const InputDecoration(
                      labelText: 'Lampiran Dokumen (opsional)',
                    ),
                    onSaved: (v) => _lampiranDokumen = v?.trim(),
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
