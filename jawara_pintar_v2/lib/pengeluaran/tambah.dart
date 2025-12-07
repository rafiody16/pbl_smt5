import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

class Tambah extends StatefulWidget {
  const Tambah({super.key});

  @override
  State<Tambah> createState() => _TambahState();
}

class _TambahState extends State<Tambah> {
  final _formKey = GlobalKey<FormState>();
  String? kategori;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  DateTime? tanggal;

  String? _buktiPath; // simulasi file bukti

  @override
  void dispose() {
    namaController.dispose();
    nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    String formatNominalHint() {
      if (nominalController.text.isEmpty) return '';
      final n = int.tryParse(nominalController.text) ?? 0;
      final s = n.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
      return 'Rp $s';
    }

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text('Buat Pengeluaran Baru'),
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
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  // Nama Pengeluaran
                  const Text(
                    'Nama Pengeluaran',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: Biaya Kebersihan',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama pengeluaran harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Tanggal Pengeluaran
                  const Text(
                    'Tanggal Pengeluaran',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
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
                      if (picked != null) {
                        setState(() => tanggal = picked);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'dd/mm/yyyy',
                      labelText: tanggal == null
                          ? null
                          : '${tanggal!.day}/${tanggal!.month}/${tanggal!.year}',
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    validator: (_) {
                      if (tanggal == null) {
                        return 'Tanggal pengeluaran harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Kategori Pengeluaran
                  const Text(
                    'Kategori Pengeluaran',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: kategori,
                    hint: const Text('-- Pilih Kategori --'),
                    items: const [
                      DropdownMenuItem(
                        value: 'operasional',
                        child: Text('Operasional'),
                      ),
                      DropdownMenuItem(
                        value: 'perawatan',
                        child: Text('Perawatan'),
                      ),
                      DropdownMenuItem(
                        value: 'lainnya',
                        child: Text('Lainnya'),
                      ),
                    ],
                    onChanged: (val) => setState(() => kategori = val),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Kategori harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Nominal
                  const Text(
                    'Nominal',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nominalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nominal pengeluaran',
                      labelText: formatNominalHint().isEmpty
                          ? null
                          : formatNominalHint(),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nominal harus diisi';
                      }
                      final n = double.tryParse(v.replaceAll('.', ''));
                      if (n == null || n <= 0) {
                        return 'Masukkan nominal yang valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Bukti Pengeluaran (klik)
                  const Text(
                    'Bukti Pengeluaran',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // Simulasi upload
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Upload Bukti'),
                          content: const Text(
                            'Fitur upload file belum terhubung.\n'
                            'Klik "Pilih" untuk simulasi bukti ter-upload.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _buktiPath =
                                      'bukti_pengeluaran_${DateTime.now().millisecondsSinceEpoch}.jpg';
                                });
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Bukti pengeluaran berhasil diset',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Pilih'),
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
                                Icon(
                                  Icons.upload_file,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Klik untuk upload bukti\n(.png / .jpg)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _buktiPath!,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5AE0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // TODO: kirim ke API / simpan ke database
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Pengeluaran '${namaController.text}' berhasil disimpan",
                                  ),
                                ),
                              );
                              Navigator.pop(
                                context,
                              ); // kembali ke daftar, jika mau
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
                            namaController.clear();
                            nominalController.clear();
                            setState(() {
                              kategori = null;
                              tanggal = null;
                              _buktiPath = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
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
