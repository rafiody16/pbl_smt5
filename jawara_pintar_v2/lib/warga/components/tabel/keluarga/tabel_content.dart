import 'package:flutter/material.dart';
import '../../shared/status_chip.dart';
import '../../shared/action_buttons_keluarga.dart';
import '../../detail/keluarga_detail_page.dart';

class TabelContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;

  const TabelContent({
    super.key,
    required this.filteredData,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredData.isEmpty) {
      return _buildEmptyState();
    }

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) => Colors.blueGrey[50],
          ),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          dataTextStyle: const TextStyle(color: Colors.black87),
          columnSpacing: 20,
          horizontalMargin: 20,
          headingRowHeight: 50,
          dataRowHeight: 60,
          columns: const [
            DataColumn(
              label: Text('NO'),
              numeric: true,
            ),
            DataColumn(label: Text('NAMA KELUARGA')),
            DataColumn(label: Text('KEPALA KELUARGA')),
            DataColumn(label: Text('ALAMAT RUMAH')),
            DataColumn(label: Text('STATUS KEPEMILIKAN')),
            DataColumn(
              label: Center(
                child: Text('STATUS'),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text('AKSI'),
              ),
            ),
          ],
          rows: filteredData.map((keluarga) => _buildDataRow(keluarga, context)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> keluarga, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(keluarga['no'].toString()),
          ),
        ),
        DataCell(Text(keluarga['nama_keluarga'])),
        DataCell(Text(keluarga['kepala_keluarga'])),
        DataCell(
          Container(
            width: 200,
            child: Text(
              keluarga['alamat'],
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(keluarga['status_kepemilikan']),
          ),
        ),
        DataCell(
          Center(
            child: StatusChip(status: keluarga['status']),
          ),
        ),
        DataCell(
          Center(
            child: ActionButtonsKeluarga(
              onDetail: () => _showDetail(keluarga, context),
            ),
          ),
        ),
      ],
    );
  }

  void _showDetail(Map<String, dynamic> keluarga, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KeluargaDetailPage(keluarga: keluarga),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Tidak ada data yang ditemukan",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}