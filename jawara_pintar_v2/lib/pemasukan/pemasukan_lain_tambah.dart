import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

class PemasukanLainTambah extends StatefulWidget {
  const PemasukanLainTambah({super.key});

  @override
  State<PemasukanLainTambah> createState() => _PemasukanLainTambahState();
}

class _PemasukanLainTambahState extends State<PemasukanLainTambah> {
  final _formKey = GlobalKey<FormState>();
  String? kategori;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  DateTime? tanggal;

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(title: const Text('Buat Pemasukan Non Iuran Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const Text('Nama Pemasukan'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan nama pemasukan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Tanggal Pemasukan'),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => tanggal = picked);
                    },
                    decoration: InputDecoration(
                      hintText: tanggal == null
                          ? '-- Pilih Tanggal --'
                          : '${tanggal!.day}/${tanggal!.month}/${tanggal!.year}',
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Kategori Pemasukan'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: kategori,
                    hint: const Text('-- Pilih Kategori --'),
                    items: const [
                      DropdownMenuItem(value: 'donasi', child: Text('Donasi')),
                      DropdownMenuItem(value: 'sumbangan', child: Text('Sumbangan')),
                      DropdownMenuItem(value: 'lainnya', child: Text('Lainnya')),
                    ],
                    onChanged: (val) => setState(() => kategori = val),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Nominal'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nominalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan nominal pemasukan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Bukti Pemasukan'),
                  const SizedBox(height: 8),
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    color: Colors.grey.shade100,
                    child: const Text('Upload bukti pemasukan (.png/.jpg)'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {},
                        child: const Text('Submit'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          namaController.clear();
                          nominalController.clear();
                          setState(() {
                            kategori = null;
                            tanggal = null;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
