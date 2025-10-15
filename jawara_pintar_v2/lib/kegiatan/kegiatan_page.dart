import 'package:flutter/material.dart';

class KegiatanPage extends StatelessWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [
      {
        'no': '1',
        'nama': 'Musy',
        'kategori': 'Komunitas & Sosial',
        'penanggung': 'Pak',
        'tanggal': '12 Oktober 2025',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tombol filter di kanan atas
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),

              // DataTable
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  dataTextStyle: const TextStyle(color: Colors.black87),
                  columns: const [
                    DataColumn(label: Text('NO')),
                    DataColumn(label: Text('NAMA KEGIATAN')),
                    DataColumn(label: Text('KATEGORI')),
                    DataColumn(label: Text('PENANGGUNG JAWAB')),
                    DataColumn(label: Text('TANGGAL PELAKSANAAN')),
                    DataColumn(label: Text('AKSI')),
                  ],
                  rows: data.map((row) {
                    return DataRow(
                      cells: [
                        DataCell(Text(row['no']!)),
                        DataCell(Text(row['nama']!)),
                        DataCell(Text(row['kategori']!)),
                        DataCell(Text(row['penanggung']!)),
                        DataCell(Text(row['tanggal']!)),
                        const DataCell(Icon(Icons.more_horiz)),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 8),

              // Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {},
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A5AE0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
