import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../sidebar/sidebar.dart';
import '../../../services/toast_service.dart';
import '../../dashboard/keuangan.dart';
import '../../../data/data_broadcast.dart';

class BroadcastTambahPage extends StatefulWidget {
  const BroadcastTambahPage({super.key});

  @override
  State<BroadcastTambahPage> createState() => _BroadcastTambahPageState();
}

class _BroadcastTambahPageState extends State<BroadcastTambahPage> {
  final _formKey = GlobalKey<FormState>();

  String _judul = '';
  String _isiPesan = '';
  String? _tanggalPublikasi;

  Uint8List? _lampiranGambarBytes;
  String? _lampiranGambarName;

  Uint8List? _lampiranDokumenBytes;
  String? _lampiranDokumenName;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id', 'ID'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tanggalPublikasi = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _lampiranGambarBytes = result.files.single.bytes;
        _lampiranGambarName = result.files.single.name;
      });
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _lampiranDokumenBytes = result.files.single.bytes;
        _lampiranDokumenName = result.files.single.name;
      });
    }
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newBroadcast = {
        "judul": _judul,
        "isi_pesan": _isiPesan,
        "tanggal_publikasi": _tanggalPublikasi,
        "dibuat_oleh": "Admin Jawara",
        "lampiran_gambar": _lampiranGambarName ?? "default.jpg",
        "lampiran_dokumen": _lampiranDokumenName ?? "default.pdf",
      };

      BroadcastData.dataBroadcast.add(newBroadcast);

      ToastService.showSuccess(context, "Broadcast berhasil ditambahkan");

      Future.delayed(const Duration(milliseconds: 1500), () {
        _navigateToDashboard();
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardPage()),
      (route) => false,
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _judul = '';
      _isiPesan = '';
      _tanggalPublikasi = null;
      _lampiranGambarBytes = null;
      _lampiranGambarName = null;
      _lampiranDokumenBytes = null;
      _lampiranDokumenName = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form telah direset'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          "Tambah Broadcast",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _navigateToDashboard,
        ),
      ),
      drawer: const Sidebar(userEmail: 'admin@jawara.com'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                    Row(
                      children: [
                        Container(
                          width: 55,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.campaign_outlined,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            "Tambah Broadcast",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 24),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Judul Broadcast',
                              hintText: 'Contoh: Pengumuman Rapat RT',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Judul wajib diisi' : null,
                            onSaved: (value) => _judul = value!,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Isi Pesan',
                              hintText: 'Tuliskan isi broadcast di sini',
                            ),
                            maxLines: 4,
                            validator: (value) =>
                                value!.isEmpty ? 'Pesan wajib diisi' : null,
                            onSaved: (value) => _isiPesan = value!,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Tanggal Publikasi',
                              hintText: 'Pilih tanggal publikasi',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today_outlined),
                                onPressed: _selectDate,
                              ),
                            ),
                            controller: TextEditingController(
                              text: _tanggalPublikasi ?? '',
                            ),
                            validator: (value) => value!.isEmpty
                                ? 'Tanggal publikasi wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            "Lampiran Gambar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.image_outlined),
                                label: const Text("Pilih Gambar"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (_lampiranGambarBytes != null)
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      _lampiranGambarBytes!,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            "Lampiran Dokumen",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickDocument,
                                icon: const Icon(Icons.attach_file),
                                label: const Text("Pilih Dokumen"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (_lampiranDokumenName != null)
                                Expanded(
                                  child: Text(
                                    _lampiranDokumenName!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Reset"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Tambah"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
