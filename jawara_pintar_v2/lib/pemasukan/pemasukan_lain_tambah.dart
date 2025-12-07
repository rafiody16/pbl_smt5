// import 'package:flutter/material.dart';
// import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

// class PemasukanLainTambah extends StatefulWidget {
//   const PemasukanLainTambah({super.key});

//   @override
//   State<PemasukanLainTambah> createState() => _PemasukanLainTambahState();
// }
// class _PemasukanLainTambahState extends State<PemasukanLainTambah> {
//   final _formKey = GlobalKey<FormState>();
//   String? kategori;
//   final TextEditingController namaController = TextEditingController();
//   final TextEditingController nominalController = TextEditingController();
//   DateTime? tanggal;

//   @override
//   Widget build(BuildContext context) {
//     const String currentUserEmail = "user@example.com";

//     return Scaffold(
//       drawer: const Sidebar(userEmail: currentUserEmail),
//       backgroundColor: const Color(0xfff0f4f7),
//       appBar: AppBar(title: const Text('Buat Pemasukan Non Iuran Baru')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: ListView(
//                 children: [
//                   const Text('Nama Pemasukan'),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: namaController,
//                     decoration: const InputDecoration(
//                       hintText: 'Masukkan nama pemasukan',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text('Tanggal Pemasukan'),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     readOnly: true,
//                     onTap: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2020),
//                         lastDate: DateTime(2100),
//                       );
//                       if (picked != null) setState(() => tanggal = picked);
//                     },
//                     decoration: InputDecoration(
//                       hintText: tanggal == null
//                           ? '-- Pilih Tanggal --'
//                           : '${tanggal!.day}/${tanggal!.month}/${tanggal!.year}',
//                       suffixIcon: const Icon(Icons.calendar_today),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text('Kategori Pemasukan'),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<String>(
//                     value: kategori,
//                     hint: const Text('-- Pilih Kategori --'),
//                     items: const [
//                       DropdownMenuItem(value: 'donasi', child: Text('Donasi')),
//                       DropdownMenuItem(value: 'sumbangan', child: Text('Sumbangan')),
//                       DropdownMenuItem(value: 'lainnya', child: Text('Lainnya')),
//                     ],
//                     onChanged: (val) => setState(() => kategori = val),
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text('Nominal'),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: nominalController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       hintText: 'Masukkan nominal pemasukan',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text('Bukti Pemasukan'),
//                   const SizedBox(height: 8),
//                   Container(
//                     height: 100,
//                     alignment: Alignment.center,
//                     color: Colors.grey.shade100,
//                     child: const Text('Upload bukti pemasukan (.png/.jpg)'),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                         ),
//                         onPressed: () {},
//                         child: const Text('Submit'),
//                       ),
//                       const SizedBox(width: 12),
//                       OutlinedButton(
//                         onPressed: () {
//                           namaController.clear();
//                           nominalController.clear();
//                           setState(() {
//                             kategori = null;
//                             tanggal = null;
//                           });
//                         },
//                         child: const Text('Reset'),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Pastikan path ini benar

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

  // Simulasi file bukti (bisa dikembangkan jadi File/Uint8List)
  String? _buktiPath; 

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    // Formatter untuk nominal (opsional untuk ditampilkan lebih baik)
    String formatNominal() {
      final nominal = nominalController.text;
      if (nominal.isEmpty) return '';
      final number = int.tryParse(nominal) ?? 0;
      return 'Rp ${number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      )}';
    }

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text('Buat Pemasukan Non-Iuran Baru'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  // === 1. Nama Pemasukan ===
                  const Text(
                    'Nama Pemasukan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Donasi Bencana',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama pemasukan harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // === 2. Tanggal Pemasukan ===
                  const Text(
                    'Tanggal Pemasukan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => tanggal = picked);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'dd/mm/yyyy',
                      labelText: tanggal == null ? null : '${tanggal!.day}/${tanggal!.month}/${tanggal!.year}',
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    validator: (value) {
                      if (tanggal == null) {
                        return 'Tanggal harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // === 3. Kategori Pemasukan ===
                  const Text(
                    'Kategori Pemasukan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: kategori,
                    hint: const Text('-- Pilih Kategori --'),
                    items: const [
                      DropdownMenuItem(value: 'donasi', child: Text('Donasi')),
                      DropdownMenuItem(value: 'sumbangan', child: Text('Sumbangan')),
                      DropdownMenuItem(value: 'lainnya', child: Text('Lainnya')),
                    ],
                    onChanged: (String? val) {
                      setState(() => kategori = val);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih kategori';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // === 4. Nominal ===
                  const Text(
                    'Nominal',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nominalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nominal',
                      labelText: formatNominal().isNotEmpty ? formatNominal() : null,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nominal harus diisi';
                      }
                      final number = double.tryParse(value);
                      if (number == null || number <= 0) {
                        return 'Masukkan nominal valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // === 5. Bukti Pemasukan (clickable) ===
                  const Text(
                    'Bukti Pemasukan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // Simulasi upload
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Upload Bukti"),
                          content: const Text("Fitur upload belum terhubung. Pilih dari galeri?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _buktiPath = "bukti_pemasukan_${DateTime.now().millisecondsSinceEpoch}.jpg";
                                });
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Bukti berhasil diunggah")),
                                );
                              },
                              child: const Text("Pilih"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      alignment: Alignment.center,
                      child: _buktiPath == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload_file, size: 32, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  'Klik untuk upload bukti\n(png/jpg/pdf)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  'Terkirim: $_buktiPath',
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // === 6. Tombol Aksi ===
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5AE0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Simulasi submit
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Pemasukan '${namaController.text}' berhasil disimpan"),
                                ),
                              );
                              Navigator.pop(context); // Kembali ke daftar
                            }
                          },
                          child: const Text('Simpan'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                            setState(() {
                              namaController.clear();
                              nominalController.clear();
                              kategori = null;
                              tanggal = null;
                              _buktiPath = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                           // Logic simpan
                        },
                        child: const Text('Submit'),
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