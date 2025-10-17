import 'package:flutter/material.dart';
import '../shared/status_chip.dart';
import '../shared/action_buttons.dart';
import '../detail/warga_detail_page.dart';
import '../../pages/warga_edit_page.dart';

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
            DataColumn(label: Text('NAMA')),
            DataColumn(label: Text('NIK')),
            DataColumn(label: Text('KELUARGA')),
            DataColumn(label: Text('JENIS KELAMIN')),
            DataColumn(
              label: Center(
                child: Text('STATUS DOMISILI'),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text('STATUS HIDUP'),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text('AKSI'),
              ),
            ),
          ],
          rows: filteredData.map((warga) => _buildDataRow(warga, context)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> warga, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(warga['no'].toString()),
          ),
        ),
        DataCell(Text(warga['nama'])),
        DataCell(Text(warga['nik'])),
        DataCell(Text(warga['keluarga'])),
        DataCell(Text(warga['jenis_kelamin'])),
        DataCell(
          Center(
            child: StatusChip(status: warga['status_domisili']),
          ),
        ),
        DataCell(
          Center(
            child: StatusChip(status: warga['status_hidup']),
          ),
        ),
        DataCell(
          Center(
            child: ActionButtons(
              onDetail: () => _showDetail(warga, context),
              onEdit: () => _editData(warga, context),
            ),
          ),
        ),
      ],
    );
  }

  void _showDetail(Map<String, dynamic> warga, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WargaDetailPage(warga: warga),
      ),
    );
  }

  void _editData(Map<String, dynamic> warga, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WargaEditPage(warga: warga),
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