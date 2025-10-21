import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/data_broadcast.dart';

class BroadcastEditPage extends StatefulWidget {
  final Map<String, dynamic>? broadcast; // null jika tambah baru
  const BroadcastEditPage({super.key, this.broadcast});

  @override
  State<BroadcastEditPage> createState() => _BroadcastEditPageState();
}

class _BroadcastEditPageState extends State<BroadcastEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Field data
  String _judul = '';
  String _isiPesan = '';
  DateTime? _tanggalPublikasi;
  String _dibuatOleh = '';
  String _lampiranGambar = '';
  String _lampiranDokumen = '';

  @override
  void initState() {
    super.initState();
    if (widget.broadcast != null) {
      final data = widget.broadcast!;
      _judul = data['judul'] ?? '';
      _isiPesan = data['isi_pesan'] ?? '';
      _dibuatOleh = data['dibuat_oleh'] ?? '';
      _lampiranGambar = data['lampiran_gambar'] ?? '';
      _lampiranDokumen = data['lampiran_dokumen'] ?? '';
      if (data['tanggal_publikasi'] != null &&
          data['tanggal_publikasi'] != '') {
        _tanggalPublikasi = DateFormat(
          'd MMMM yyyy',
          'id_ID',
        ).parse(data['tanggal_publikasi']);
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final tanggalFormatted = _tanggalPublikasi != null
          ? DateFormat('d MMMM yyyy', 'id_ID').format(_tanggalPublikasi!)
          : '';

      final newData = {
        "judul": _judul,
        "isi_pesan": _isiPesan,
        "tanggal_publikasi": tanggalFormatted,
        "dibuat_oleh": _dibuatOleh,
        "lampiran_gambar": _lampiranGambar,
        "lampiran_dokumen": _lampiranDokumen,
      };

      print("=== Data Broadcast ===");
      print(newData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Broadcast berhasil disimpan!')),
      );
      Navigator.pop(context, newData);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id', 'ID'),
      initialDate: _tanggalPublikasi ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalPublikasi = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanggalController = TextEditingController(
      text: _tanggalPublikasi != null
          ? DateFormat('d MMMM yyyy', 'id_ID').format(_tanggalPublikasi!)
          : '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.broadcast == null ? "Tambah Broadcast" : "Edit Broadcast",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Judul"),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _judul,
                    decoration: const InputDecoration(
                      hintText: "Contoh: Gotong Royong",
                    ),
                    onSaved: (value) => _judul = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? "Judul wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Isi Pesan"),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _isiPesan,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Tuliskan isi pesan broadcast...",
                    ),
                    onSaved: (value) => _isiPesan = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? "Isi pesan wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Tanggal Publikasi"),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: tanggalController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "--/--/----",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: _selectDate,
                      ),
                    ),
                    validator: (_) => _tanggalPublikasi == null
                        ? "Tanggal wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Dibuat Oleh"),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _dibuatOleh,
                    decoration: const InputDecoration(
                      hintText: "Contoh: Admin Jawara",
                    ),
                    onSaved: (value) => _dibuatOleh = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? "Nama pembuat wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  const Text("Lampiran Gambar"),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _lampiranGambar,
                    decoration: const InputDecoration(
                      hintText: "Contoh: a.jpg",
                    ),
                    onSaved: (value) => _lampiranGambar = value ?? '',
                  ),
                  const SizedBox(height: 16),

                  const Text("Lampiran Dokumen"),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _lampiranDokumen,
                    decoration: const InputDecoration(
                      hintText: "Contoh: a.pdf",
                    ),
                    onSaved: (value) => _lampiranDokumen = value ?? '',
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => _formKey.currentState!.reset(),
                        child: const Text("Reset"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Simpan"),
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
