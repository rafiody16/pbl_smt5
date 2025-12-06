import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan path sesuai struktur proyekmu

class PemasukanLainDaftarData {
  final int no;
  final String nama;
  final String jenisPengeluaran;
  final DateTime tanggal;
  final double nominal;

  PemasukanLainDaftarData({
    required this.no,
    required this.nama,
    required this.jenisPengeluaran,
    required this.tanggal,
    required this.nominal,
  });
}

class PemasukanLainDaftar extends StatefulWidget {
  const PemasukanLainDaftar({super.key});

  @override
  State<PemasukanLainDaftar> createState() => _PemasukanLainDaftarState();
}

class _PemasukanLainDaftarState extends State<PemasukanLainDaftar> {
  // Data contoh statis
  final List<PemasukanLainDaftarData> _PemasukanLainDaftarList = [
    PemasukanLainDaftarData(
      no: 1,
      nama: 'Daftar Kebersihan',
      jenisPengeluaran: 'Bulanan',
      tanggal: DateTime(1111, 1, 1, 1, 1),
      nominal: 25000,
    ),
    PemasukanLainDaftarData(
      no: 2,
      nama: 'Daftar Keamanan',
      jenisPengeluaran: 'Bulanan',
      tanggal: DateTime(1112, 1, 1, 1, 1),
      nominal: 20000,
    ),
    PemasukanLainDaftarData(
      no: 3,
      nama: 'Daftar Sosial',
      jenisPengeluaran: 'Khusus',
      tanggal: DateTime(1113, 1, 1, 1, 1),
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
                    "Tambah Daftar",
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
                              'NAMA',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'JENIS PENGELUARAN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn( 
                            label: Text( 
                              'TANGGAL', 
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
                        rows: _PemasukanLainDaftarList.map((daftar) {
                          final currencyFormatter = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 0,
                          );
                          final dateFormatter = DateFormat( 
                            'd MMM yyyy HH:mm', 
                            'id_ID', 
                          );

                          return DataRow(
                            cells: [
                              DataCell(Text(daftar.no.toString())),
                              DataCell( Text(dateFormatter.format(daftar.tanggal)), ),
                              DataCell(Text(daftar.nama)),
                              DataCell(Text(daftar.jenisPengeluaran)),
                              DataCell(
                                Text(currencyFormatter.format(daftar.nominal)),
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
