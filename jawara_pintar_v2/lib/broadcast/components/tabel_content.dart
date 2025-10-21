import 'package:flutter/material.dart';
import '../../warga/components/shared/action_buttons_warga.dart';
import '../../data/data_broadcast.dart';
import 'edit/edit_broadcast_page.dart';
import 'detail/detail_broadcast_page.dart';

class TabelContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final int currentPage;
  final int itemsPerPage;

  const TabelContent({
    super.key,
    required this.filteredData,
    this.currentPage = 1,
    this.itemsPerPage = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredData.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) => Colors.blueGrey[50],
                ),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 15,
                ),
                dataTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                columnSpacing: 30,
                horizontalMargin: 20,
                headingRowHeight: 55,
                dataRowHeight: 65,
                columns: const [
                  DataColumn(label: Text('NO')),
                  DataColumn(label: Text('PENGIRIM')),
                  DataColumn(label: Text('JUDUL')),
                  DataColumn(label: Text('TANGGAL')),
                  DataColumn(label: Center(child: Text('AKSI'))),
                ],
                rows: filteredData
                    .asMap()
                    .entries
                    .map(
                      (entry) => _buildDataRow(entry.key, entry.value, context),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  DataRow _buildDataRow(
    int index,
    Map<String, dynamic> broadcast,
    BuildContext context,
  ) {
    int nomorUrut = ((currentPage - 1) * itemsPerPage) + index + 1;

    return DataRow(
      cells: [
        DataCell(Center(child: Text(nomorUrut.toString()))),
        DataCell(Text(broadcast['dibuat_oleh'])),
        DataCell(Text(broadcast['judul'])),
        DataCell(Text(broadcast['tanggal_publikasi'])),
        DataCell(
          Center(
            child: ActionButtons(
              onDetail: () => _showDetail(broadcast, context),
              onEdit: () => _editData(broadcast, context),
            ),
          ),
        ),
      ],
    );
  }

  void _showDetail(Map<String, dynamic> broadcast, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BroadcastDetailPage(broadcast: broadcast),
      ),
    );
  }

  void _editData(Map<String, dynamic> broadcast, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BroadcastEditPage(broadcast: broadcast),
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
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
