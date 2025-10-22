import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

class Tagihan extends StatefulWidget {
  const Tagihan({super.key});

  @override
  State<Tagihan> createState() => _TagihanState();
}

class _TagihanState extends State<Tagihan> {
  final List<Map<String, dynamic>> data = [
      {
        'no': 1,
        'keluarga': 'Keluarga Habibie Ed Dien',
        'status': 'Aktif',
        'iuran': 'Mingguan',
        'kode': 'IR175458A501',
        'nominal': 'Rp 10,00',
        'periode': '8 Oktober 2025',
        'statusTagihan': 'Belum Dibayar'
      },
      {
        'no': 2,
        'keluarga': 'Keluarga Mara Nunez',
        'status': 'Aktif',
        'iuran': 'Agustusan',
        'kode': 'IR224406BC02',
        'nominal': 'Rp 15,00',
        'periode': '10 Oktober 2025',
        'statusTagihan': 'Belum Dibayar'
      },
    ];

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(title: const Text('Daftar Tagihan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                      icon: const Icon(Icons.filter_alt),
                      label: const Text('Filter'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Cetak PDF'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Nama Keluarga')),
                        DataColumn(label: Text('Status Keluarga')),
                        DataColumn(label: Text('Iuran')),
                        DataColumn(label: Text('Kode Tagihan')),
                        DataColumn(label: Text('Nominal')),
                        DataColumn(label: Text('Periode')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: data.map((row) {
                        return DataRow(cells: [
                          DataCell(Text(row['no'].toString())),
                          DataCell(Text(row['keluarga'])),
                          DataCell(_buildStatusChip(row['status'])),
                          DataCell(Text(row['iuran'])),
                          DataCell(Text(row['kode'])),
                          DataCell(Text(row['nominal'])),
                          DataCell(Text(row['periode'])),
                          DataCell(_buildStatusTagihan(row['statusTagihan'])),
                          const DataCell(Icon(Icons.more_horiz)),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: const TextStyle(color: Colors.green)),
    );
  }

  Widget _buildStatusTagihan(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: const TextStyle(color: Colors.orange)),
    );
  }
}
