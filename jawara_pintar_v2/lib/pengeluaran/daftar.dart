import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
import 'package:jawara_pintar_v2/providers/keuangan_provider.dart'; // Sesuaikan path jika perlu
import 'package:jawara_pintar_v2/models/keuangan_models.dart';
import 'tambah.dart'; // Import file tambah.dart yang satu folder

class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  final TextEditingController _searchController = TextEditingController();
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  final dateFormatter = DateFormat('dd/MM/yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<KeuanganProvider>(context, listen: false).initData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(userEmail: "user@example.com"),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Daftar Pengeluaran"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Consumer<KeuanganProvider>(
        builder: (context, provider, child) {
          var listData = provider.listPengeluaran;

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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: "Cari pengeluaran...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigasi ke halaman tambah
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => const PengeluaranTambahPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "Tambah",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
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
                  if (provider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (listData.isEmpty)
                    const Center(
                      child: Text(
                        "Data tidak ditemukan.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
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

  Widget _buildCard(PengeluaranModel item, String namaKategori) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Color(0xFFF76C6C), width: 5),
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
            Text(
              namaKategori.toUpperCase(),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            Text(
              item.judul,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateFormatter.format(item.tanggalTransaksi)),
                Text(
                  currencyFormatter.format(item.nominal),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF76C6C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
