import 'package:flutter/material.dart';
import '../../../../data/kegiatan_data.dart';
import 'detail/detail_kegiatan_page.dart';
import '../components/edit/edit_kegiatan_page.dart';

class ListContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final ScrollController scrollController;
  final int totalKegiatan;

  const ListContent({
    super.key,
    required this.filteredData,
    required this.scrollController,
    required this.totalKegiatan,
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
        final kegiatan = filteredData[index];
        return _buildKegiatanCard(kegiatan, index + 1, context);
      },
    );
  }

  Widget _buildKegiatanCard(
    Map<String, dynamic> kegiatan,
    int nomorUrut,
    BuildContext context,
  ) {
    final nama = kegiatan['nama']?.toString() ?? '(Tanpa nama)';
    final kategori = kegiatan['kategori']?.toString() ?? '(Tidak ada kategori)';
    final penanggungJawab =
        kegiatan['penanggungJawab']?.toString() ?? 'Tidak diketahui';
    final tanggal = kegiatan['tanggal']?.toString() ?? '-';

    return Dismissible(
      key: ValueKey(kegiatan['id'] ?? nomorUrut),
      background: _buildSwipeActionLeft(),
      secondaryBackground: _buildSwipeActionRight(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Geser ke kanan untuk Edit
          _editKegiatan(kegiatan, context);
          return false; // Jangan hapus dari list
        } else if (direction == DismissDirection.endToStart) {
          // Geser ke kiri untuk Hapus
          _deleteKegiatan(kegiatan, context);
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
            onTap: () => _showDetail(kegiatan, context),
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
                          nama,
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
                          kategori,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoChip(
                                penanggungJawab,
                                Icons.group,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(tanggal, Icons.person, Colors.grey),
                          ],
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

  void _editKegiatan(
    Map<String, dynamic> kegiatan,
    BuildContext context,
  ) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KegiatanEditPage(kegiatan: kegiatan),
      ),
    );

    if (updatedData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kegiatan berhasil diperbarui!')),
      );
    }
  }

  void _deleteKegiatan(
    Map<String, dynamic> kegiatan,
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

  Widget _buildInfoChip(String text, IconData icon, Color color) {
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
            text,
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

  void _showDetail(Map<String, dynamic> kegiatan, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KegiatanDetailPage(kegiatan: kegiatan),
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
