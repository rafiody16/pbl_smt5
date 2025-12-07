import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
import '../providers/keuangan_provider.dart';
import '../providers/warga_provider.dart';
import '../models/keuangan_models.dart';

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedKategoriId;
  String? _selectedWargaNik; // UBAH: Jadi String karena pakai NIK

  DateTime _selectedBulan = DateTime.now();
  final TextEditingController _nominalController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<KeuanganProvider>(context, listen: false).initData();
      // Pastikan WargaProvider punya fungsi untuk load data
      // Provider.of<WargaProvider>(context, listen: false).getAllWarga();
    });
  }

  @override
  Widget build(BuildContext context) {
    final keuanganProv = Provider.of<KeuanganProvider>(context);
    final wargaProv = Provider.of<WargaProvider>(context);

    // Filter kategori iuran (yang punya nominal default)
    final listKategori = keuanganProv.listKategori
        .where((e) => e.nominalDefault > 0)
        .toList();

    return Scaffold(
      drawer: const Sidebar(userEmail: "admin@jawara.com"),
      appBar: AppBar(title: const Text("Buat Tagihan Iuran")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
                  const Text(
                    "Informasi Tagihan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 30),

                  // 1. Pilih Warga (PERBAIKAN DISINI)
                  DropdownButtonFormField<String>(
                    // Tipe jadi String
                    decoration: const InputDecoration(
                      labelText: "Pilih Warga",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedWargaNik,
                    items: wargaProv.wargaList.map((warga) {
                      return DropdownMenuItem(
                        value: warga.nik, // Gunakan NIK
                        child: Text(
                          "${warga.namaLengkap} (${warga.statusDomisili})", // Gunakan namaLengkap
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedWargaNik = val),
                    validator: (v) => v == null ? "Wajib dipilih" : null,
                    isExpanded: true,
                  ),
                  const SizedBox(height: 20),

                  // 2. Pilih Jenis Iuran
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: "Jenis Iuran",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedKategoriId,
                    items: listKategori.map((kat) {
                      return DropdownMenuItem(
                        value: kat.id,
                        child: Text(kat.namaKategori),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedKategoriId = val;
                        // Auto-fill nominal dari default
                        final selected = listKategori.firstWhere(
                          (e) => e.id == val,
                        );
                        _nominalController.text = selected.nominalDefault
                            .toStringAsFixed(0);
                      });
                    },
                    validator: (v) => v == null ? "Wajib dipilih" : null,
                  ),
                  const SizedBox(height: 20),

                  // 3. Periode (Bulan)
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Periode Tagihan",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    controller: TextEditingController(
                      text: DateFormat(
                        'MMMM yyyy',
                        'id_ID',
                      ).format(_selectedBulan),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedBulan,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null)
                        setState(() => _selectedBulan = picked);
                    },
                  ),
                  const SizedBox(height: 20),

                  // 4. Nominal
                  TextFormField(
                    controller: _nominalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Nominal Tagihan",
                      border: OutlineInputBorder(),
                      prefixText: "Rp ",
                    ),
                    validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                  ),
                  const SizedBox(height: 30),

                  // Tombol Submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5AE0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _isLoading = true);

                                // Cari nama warga untuk dimasukkan ke judul
                                final wargaSelected = wargaProv.wargaList
                                    .firstWhere(
                                      (w) => w.nik == _selectedWargaNik,
                                    );
                                final namaKategori = listKategori
                                    .firstWhere(
                                      (e) => e.id == _selectedKategoriId,
                                    )
                                    .namaKategori;
                                final periode = DateFormat(
                                  'MMMM yyyy',
                                  'id_ID',
                                ).format(_selectedBulan);

                                // Format Judul: "Iuran Sampah - Budi - Januari 2025"
                                final judulTagihan =
                                    "$namaKategori - ${wargaSelected.namaLengkap} - $periode";

                                final newTagihan = PemasukanModel(
                                  judul: judulTagihan,
                                  kategoriId: _selectedKategoriId!,
                                  nominal: double.parse(
                                    _nominalController.text.replaceAll('.', ''),
                                  ),
                                  tanggalTransaksi: DateTime.now(),
                                  statusBayar: "Belum Lunas",
                                  metodePembayaran: "-",
                                  buktiFoto: null,
                                  // Note: Kita belum simpan NIK ke DB keuangan (karena tabelnya belum ada kolom nik/warga_id)
                                  // Jadi kita simpan infonya di Judul dulu.
                                );

                                final success = await keuanganProv
                                    .tambahPemasukan(newTagihan);
                                setState(() => _isLoading = false);

                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Tagihan berhasil dibuat!"),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Buat Tagihan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
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
