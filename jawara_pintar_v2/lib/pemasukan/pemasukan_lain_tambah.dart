import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
import '../providers/keuangan_provider.dart';
import '../models/keuangan_models.dart';

class PemasukanLainTambah extends StatefulWidget {
  const PemasukanLainTambah({super.key});

  @override
  State<PemasukanLainTambah> createState() => _PemasukanLainTambahState();
}

class _PemasukanLainTambahState extends State<PemasukanLainTambah> {
  final _formKey = GlobalKey<FormState>();

  // State Form
  int? selectedKategoriId; // Ganti String jadi int (ID Kategori)
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  DateTime? tanggal;
  String? _buktiPath;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Load kategori saat halaman dibuka
    Future.microtask(
      () => Provider.of<KeuanganProvider>(context, listen: false).initData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";
    final keuanganProvider = Provider.of<KeuanganProvider>(context);

    // Filter hanya kategori yang jenisnya 'pemasukan'
    final listKategori = keuanganProvider.listKategori
        .where((e) => e.jenis == 'pemasukan')
        .toList();

    // Formatter Rupiah sederhana
    String formatNominal() {
      final nominal = nominalController.text;
      if (nominal.isEmpty) return '';
      final number = int.tryParse(nominal) ?? 0;
      return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
    }

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text('Buat Pemasukan Non-Iuran'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: namaController,
                          decoration: const InputDecoration(
                            hintText: 'Contoh: Donasi Bencana',
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 20),

                        // === 2. Tanggal ===
                        const Text(
                          'Tanggal Pemasukan',
                          style: TextStyle(fontWeight: FontWeight.w600),
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
                            if (picked != null)
                              setState(() => tanggal = picked);
                          },
                          decoration: InputDecoration(
                            hintText: 'dd/mm/yyyy',
                            labelText: tanggal == null
                                ? null
                                : '${tanggal!.day}/${tanggal!.month}/${tanggal!.year}',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (val) =>
                              tanggal == null ? 'Wajib dipilih' : null,
                        ),
                        const SizedBox(height: 20),

                        // === 3. Kategori (Dinamis dari Supabase) ===
                        const Text(
                          'Kategori Pemasukan',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: selectedKategoriId,
                          hint: const Text('-- Pilih Kategori --'),
                          items: listKategori.map((kat) {
                            return DropdownMenuItem<int>(
                              value: kat.id,
                              child: Text(kat.namaKategori),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedKategoriId = val),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) =>
                              val == null ? 'Wajib dipilih' : null,
                        ),
                        const SizedBox(height: 20),

                        // === 4. Nominal ===
                        const Text(
                          'Nominal',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nominalController,
                          keyboardType: TextInputType.number,
                          onChanged: (val) =>
                              setState(() {}), // Trigger rebuild for label
                          decoration: InputDecoration(
                            hintText: '0',
                            // Tampilkan preview rupiah di label floating
                            labelText: formatNominal().isNotEmpty
                                ? formatNominal()
                                : null,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? 'Wajib diisi'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // === 5. Bukti (Dummy path) ===
                        const Text(
                          'Bukti Pemasukan',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // Simulasi path file
                              _buktiPath = "https://via.placeholder.com/150";
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Simulasi: Foto dipilih"),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: _buktiPath == null
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.upload_file,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        "Klik untuk upload bukti",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      Text("Bukti Terlampir"),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // === 6. Tombol Submit ===
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6A5AE0),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isSubmitting = true);

                                    // Buat Object Model
                                    final newPemasukan = PemasukanModel(
                                      judul: namaController.text,
                                      nominal: double.parse(
                                        nominalController.text,
                                      ),
                                      kategoriId: selectedKategoriId!,
                                      tanggalTransaksi: tanggal!,
                                      buktiFoto: _buktiPath,
                                      statusBayar: 'Lunas', // Default
                                      metodePembayaran: 'Tunai', // Default
                                    );

                                    // Kirim ke Provider
                                    final success = await keuanganProvider
                                        .tambahPemasukan(newPemasukan);

                                    setState(() => _isSubmitting = false);

                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Data berhasil disimpan!",
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } else if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Gagal menyimpan data.",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Simpan Data'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
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
