import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan path sesuai struktur proyekmu

class KategoriIuranData {
  final int no;
  final String namaIuran;
  final String jenisIuran;
  final double nominal;

  KategoriIuranData({
    required this.no,
    required this.namaIuran,
    required this.jenisIuran,
    required this.nominal,
  });
}

class KategoriIuran extends StatefulWidget {
  const KategoriIuran({super.key});

  @override
  State<KategoriIuran> createState() => _KategoriIuranState();
}

class _KategoriIuranState extends State<KategoriIuran> {
  // Data contoh statis
  final List<KategoriIuranData> _kategoriIuranList = [
    KategoriIuranData(
      no: 1,
      namaIuran: 'Iuran Kebersihan',
      jenisIuran: 'Bulanan',
      nominal: 25000,
    ),
    KategoriIuranData(
      no: 2,
      namaIuran: 'Iuran Keamanan',
      jenisIuran: 'Bulanan',
      nominal: 20000,
    ),
    KategoriIuranData(
      no: 3,
      namaIuran: 'Iuran Sosial',
      jenisIuran: 'Khusus',
      nominal: 50000,
    ),
  ];

  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com"; // Placeholder email

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Kategori Iuran"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Tambah Iuran",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: 20,
                        headingRowColor: WidgetStateProperty.all(
                          Colors.grey.shade100,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'NO',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NAMA IURAN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'JENIS IURAN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NOMINAL',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'AKSI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: _kategoriIuranList.map((iuran) {
                          final currencyFormatter = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 0,
                          );

                          return DataRow(
                            cells: [
                              DataCell(Text(iuran.no.toString())),
                              DataCell(Text(iuran.namaIuran)),
                              DataCell(Text(iuran.jenisIuran)),
                              DataCell(
                                Text(currencyFormatter.format(iuran.nominal)),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () {
                                    // Logika untuk aksi (edit, hapus, dll)
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Paginasi
              _buildPagination(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF6A5AE0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _currentPage.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
          },
        ),
      ],
    );
  }
}
