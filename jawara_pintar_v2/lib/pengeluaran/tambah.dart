import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
import 'package:jawara_pintar_v2/providers/keuangan_provider.dart';
import 'package:jawara_pintar_v2/models/keuangan_models.dart';
import 'daftar.dart'; // Import daftar agar bisa navigasi balik

class PengeluaranTambahPage extends StatefulWidget {
  const PengeluaranTambahPage({super.key});

  @override
  State<PengeluaranTambahPage> createState() => _PengeluaranTambahPageState();
}

class _PengeluaranTambahPageState extends State<PengeluaranTambahPage> {
  final _formKey = GlobalKey<FormState>();
  int? selectedKategoriId;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  DateTime? tanggal;
  String? _buktiPath;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<KeuanganProvider>(context, listen: false).initData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KeuanganProvider>(context);
    // Use the same category filtering as in kategori_iuran.dart:
    // show categories that have a default nominal > 0
    final listKategori = provider.listKategori
        .where((e) => e.nominalDefault > 0)
        .toList();

    return Scaffold(
      drawer: const Sidebar(userEmail: "user@example.com"),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(title: const Text('Buat Pengeluaran Baru')),
      body: _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: namaController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Pengeluaran',
                            border: OutlineInputBorder(),                                                                                                                  
                          ),
                          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Tanggal',
                            hintText: tanggal == null
                                ? 'Pilih Tanggal'
                                : DateFormat('dd/MM/yyyy').format(tanggal!),
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null)
                              setState(() => tanggal = picked);
                          },
                          validator: (v) =>
                              tanggal == null ? 'Wajib dipilih' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          value: selectedKategoriId,
                          hint: const Text('Pilih Kategori'),
                          items: listKategori
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.namaKategori),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedKategoriId = v),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null ? 'Wajib dipilih' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nominalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Nominal (Rp)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5AE0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isSubmitting = true);
                              final success = await provider.tambahPengeluaran(
                                PengeluaranModel(
                                  judul: namaController.text,
                                  nominal: double.parse(
                                    nominalController.text.replaceAll('.', ''),
                                  ),
                                  kategoriId: selectedKategoriId!,
                                  tanggalTransaksi: tanggal!,
                                  dikeluarkanOleh: "Admin",
                                  buktiFoto: _buktiPath,
                                ),
                              );
                              setState(() => _isSubmitting = false);
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Berhasil disimpan!"),
                                  ),
                                );
                                // Balik ke halaman daftar
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) =>
                                        const PengeluaranDaftarPage(),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Simpan Pengeluaran'),
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
