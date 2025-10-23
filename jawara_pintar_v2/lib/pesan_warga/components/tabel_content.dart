import 'package:flutter/material.dart';
import '../../../../data/data_aspirasi.dart';
import 'detail/detail_aspirasi_page.dart';
import '../components/edit/edit_aspirasi_page.dart';

class ListContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final ScrollController scrollController;
  final int totalAspirasi;

  const ListContent({
    super.key,
    required this.filteredData,
    required this.scrollController,
    required this.totalAspirasi,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredData.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filteredData.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final aspirasi = filteredData[index];
        return _buildAspirasiCard(aspirasi, index + 1, context);
      },
    );
  }

  Widget _buildAspirasiCard(
    Map<String, dynamic> aspirasi,
    int nomorUrut,
    BuildContext context,
  ) {
    final judul = aspirasi['judul']?.toString() ?? '(Tanpa judul)';
    final deskripsi =
        aspirasi['deskripsi']?.toString() ?? '(Tidak ada deskripsi)';
    final dibuat_oleh =
        aspirasi['dibuat_oleh']?.toString() ?? 'Tidak diketahui';
    final tanggal = aspirasi['tanggal_dibuat']?.toString() ?? '-';
    final status = aspirasi['status']?.toString() ?? '-';

    return Dismissible(
      key: ValueKey(aspirasi['id'] ?? nomorUrut),
      background: _buildSwipeActionLeft(),
      secondaryBackground: _buildSwipeActionRight(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Geser ke kanan untuk Edit
          _editAspirasi(aspirasi, context);
          return false; // Jangan hapus dari list
        } else if (direction == DismissDirection.endToStart) {
          // Geser ke kiri untuk Hapus
          _deleteAspirasi(aspirasi, context);
          return false; // Jangan hapus dari list
        }
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showDetail(aspirasi, context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          deskripsi,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(child: _buildStatusChip(dibuat_oleh)),
                            const SizedBox(width: 8),
                            _buildStatusChip(tanggal),
                          ],
                        ),

                        const SizedBox(height: 6),
                        Row(
                          children: [Expanded(child: _buildStatusChip(status))],
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeActionLeft() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }

  Widget _buildSwipeActionRight() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  void _editAspirasi(
    Map<String, dynamic> aspirasi,
    BuildContext context,
  ) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AspirasiEditPage(aspirasi: aspirasi),
      ),
    );

    if (updatedData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kegiatan berhasil diperbarui!')),
      );
    }
  }

  void _deleteAspirasi(
    Map<String, dynamic> aspirasi,
    BuildContext context,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus kegiatan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Broadcast berhasil dihapus!')),
      );
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon = Icons.info;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
      case 'ditolak':
        color = Colors.red;
        icon = Icons.close;
        break;
      case 'diterima':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
        ],
      ),
    );
  }

  void _showDetail(Map<String, dynamic> aspirasi, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AspirasiDetailPage(aspirasi: aspirasi),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Tidak ada data ditemukan",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Coba ubah filter pencarian Anda",
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
