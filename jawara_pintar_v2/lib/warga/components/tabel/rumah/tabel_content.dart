import 'package:flutter/material.dart';
import '../../shared/status_chip.dart';
import '../../shared/action_buttons_rumah.dart';
import '../../detail/rumah_detail_page.dart';
import '../../edit/rumah_edit_page.dart';
import '../../delete/rumah_delete_page.dart';

class TabelContentRumah extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final int currentPage;
  final int itemsPerPage;
  final VoidCallback? onDataChanged;

  const TabelContentRumah({
    super.key,
    required this.filteredData,
    this.currentPage = 1,
    this.itemsPerPage = 5,
    this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredData.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
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
            DataColumn(
              label: SizedBox(
                width: 300,
                child: Text('ALAMAT'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 120,
                child: Center(
                  child: Text('STATUS'),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 100,
                child: Center(
                  child: Text('AKSI'),
                ),
              ),
            ),
          ],
          rows: filteredData.asMap().entries.map((entry) => _buildDataRow(entry.key, entry.value, context)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(int index, Map<String, dynamic> rumah, BuildContext context) {
    int nomorUrut = ((currentPage - 1) * itemsPerPage) + index + 1;

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            child: Center(
              child: Text(nomorUrut.toString()),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 300,
            child: Text(
              rumah['alamat'],
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Center(
              child: StatusChip(status: rumah['status']),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100,
            child: Center(
              child: ActionButtonsRumah(
                onDetail: () => _showDetail(rumah, context),
                onEdit: () => _editData(rumah, context),
                onDelete: () => _deleteData(rumah, context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDetail(Map<String, dynamic> rumah, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RumahDetailPage(rumah: rumah),
      ),
    );
  }

  void _editData(Map<String, dynamic> rumah, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RumahEditPage(rumah: rumah),
      ),
    );
  }

  void _deleteData(Map<String, dynamic> rumah, BuildContext context) {
    RumahDelete.showDeleteConfirmationDialog(
      context: context,
      alamat: rumah['alamat'],
      onConfirmDelete: () => _performDelete(rumah, context),
    );
  }

  void _performDelete(Map<String, dynamic> rumah, BuildContext context) {
    RumahDelete.deleteRumah(
      context: context,
      rumah: rumah,
      onSuccess: () {
        if (onDataChanged != null) {
          onDataChanged!();
        }
      },
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