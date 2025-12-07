import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
import '../providers/keuangan_provider.dart';
import '../models/keuangan_models.dart';
import 'pemasukan_lain_tambah.dart';

class PemasukanLainDaftar extends StatefulWidget {
  const PemasukanLainDaftar({super.key});

  @override
  State<PemasukanLainDaftar> createState() => _PemasukanLainDaftarState();
}

class _PemasukanLainDaftarState extends State<PemasukanLainDaftar> {
  // === Filter Logic ===
  final TextEditingController _searchController = TextEditingController();

  // Formatters
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  final dateFormatter = DateFormat('dd/MM/yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
    // Fetch data saat halaman dibuka
    Future.microtask(
      () => Provider.of<KeuanganProvider>(context, listen: false).initData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Pemasukan Lain - Daftar"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      // Gunakan Consumer untuk mendengarkan perubahan data
      body: Consumer<KeuanganProvider>(
        builder: (context, provider, child) {
          // 1. Ambil data mentah
          var listData = provider.listPemasukan;

          // 2. Terapkan Filter Pencarian (Client Side)
          if (_searchController.text.isNotEmpty) {
            listData = listData
                .where(
                  (item) => item.judul.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
                )
                .toList();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Header & Tombol ---
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) =>
                              setState(() {}), // Rebuild saat ngetik
                          decoration: InputDecoration(
                            hintText: "Cari pemasukan...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => const PemasukanLainTambah(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "Tambah",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Loading Indicator ---
                  if (provider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  // --- Empty State ---
                  else if (listData.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: Text("Belum ada data pemasukan")),
                    )
                  // --- List Data ---
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        final item = listData[index];
                        final namaKategori = provider.getNamaKategori(
                          item.kategoriId,
                        );

                        return _buildCard(item, namaKategori);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(PemasukanModel item, String namaKategori) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Color(0xFF63C2DE), width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris 1: Kategori & Judul
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaKategori.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.judul,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    // PERBAIKAN 1: Tambahkan "?? '-'" agar jika null, dia menampilkan strip
                    item.statusBayar ?? '-',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFEEEEEE)),

            // Baris 2: Tanggal & Nominal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TANGGAL",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    // PERBAIKAN 2: Ubah 'item.tanggal' menjadi 'item.tanggalTransaksi'
                    Text(
                      dateFormatter.format(item.tanggalTransaksi),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "NOMINAL",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(item.nominal),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF6A5AE0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
