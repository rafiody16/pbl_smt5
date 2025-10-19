import 'package:flutter/material.dart';
import '../shared/status_chip_penerimaan.dart';
import '../shared/action_buttons_penerimaan.dart';
import '../shared/dialog_service.dart';
import '../detail/detail_penerimaan_page.dart';

class TabelContentPenerimaan extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final int currentPage;
  final int itemsPerPage;
  final VoidCallback? onDataChanged;

  const TabelContentPenerimaan({
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
                width: 150,
                child: Text('NAMA'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 120,
                child: Text('NIK'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 180,
                child: Text('EMAIL'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 100,
                child: Center(
                  child: Text('JENIS KELAMIN'),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 120,
                child: Center(
                  child: Text('FOTO IDENTITAS'),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 120,
                child: Center(
                  child: Text('STATUS REGISTRASI'),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 120,
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

  DataRow _buildDataRow(int index, Map<String, dynamic> pendaftaran, BuildContext context) {
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
            width: 150,
            child: Text(
              pendaftaran['nama'],
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Text(pendaftaran['nik']),
          ),
        ),
        DataCell(
          SizedBox(
            width: 180,
            child: Text(
              pendaftaran['email'],
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100,
            child: Center(
              child: Text(
                pendaftaran['jenis_kelamin'] == 'L' ? 'Laki-laki' : 'Perempuan',
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.photo, color: Colors.blue),
                onPressed: () => _showFotoIdentitas(pendaftaran, context),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Center(
              child: StatusChipPenerimaan(status: pendaftaran['status_registrasi']),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Center(
              child: ActionButtonsPenerimaan(
                onDetail: () => _showDetail(pendaftaran, context),
                onApprove: () => _approveData(pendaftaran, context),
                onReject: () => _rejectData(pendaftaran, context),
                onActivate: () => _activateData(pendaftaran, context),
                onDeactivate: () => _deactivateData(pendaftaran, context),
                status: pendaftaran['status_registrasi'],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFotoIdentitas(Map<String, dynamic> pendaftaran, BuildContext context) {
    PenerimaanWargaDialogService.showFotoIdentitasDialog(
      context: context,
      nama: pendaftaran['nama'],
      fotoIdentitas: pendaftaran['foto_identitas'],
    );
  }

  void _showDetail(Map<String, dynamic> pendaftaran, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPenerimaanPage(pendaftaran: pendaftaran),
      ),
    );
  }

  void _approveData(Map<String, dynamic> pendaftaran, BuildContext context) {
    PenerimaanWargaDialogService.showApproveDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
        if (onDataChanged != null) {
          onDataChanged!();
        }
      },
    );
  }

  void _rejectData(Map<String, dynamic> pendaftaran, BuildContext context) {
    PenerimaanWargaDialogService.showRejectDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
        if (onDataChanged != null) {
          onDataChanged!();
        }
      },
    );
  }

  void _activateData(Map<String, dynamic> pendaftaran, BuildContext context) {
    PenerimaanWargaDialogService.showActivateDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
        if (onDataChanged != null) {
          onDataChanged!();
        }
      },
    );
  }

  void _deactivateData(Map<String, dynamic> pendaftaran, BuildContext context) {
    PenerimaanWargaDialogService.showDeactivateDialog(
      context: context,
      nama: pendaftaran['nama'],
      onConfirm: () {
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