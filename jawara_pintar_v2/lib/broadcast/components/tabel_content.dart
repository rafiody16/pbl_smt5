import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/broadcast.dart';
import '../../../providers/broadcast_provider.dart';
import '../../views/broadcast/broadcast_form_page.dart';
import '../../views/broadcast/broadcast_detail_page.dart';

class ListContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final ScrollController scrollController;
  final int totalBroadcast;

  const ListContent({
    super.key,
    required this.filteredData,
    required this.scrollController,
    required this.totalBroadcast,
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
        final broadcast = filteredData[index];
        return _buildBroadcastCard(broadcast, index + 1, context);
      },
    );
  }

  Widget _buildBroadcastCard(
    Map<String, dynamic> broadcast,
    int nomorUrut,
    BuildContext context,
  ) {
    final judul = broadcast['judul']?.toString() ?? '(Tanpa Judul)';
    final deskripsi =
        broadcast['isi_pesan']?.toString() ?? '(Tidak ada deskripsi)';
    final dibuatOleh =
        broadcast['dibuat_oleh']?.toString() ?? 'Tidak diketahui';
    final tanggalPublikasi = broadcast['tanggal_publikasi']?.toString() ?? '-';

    return Dismissible(
      key: ValueKey(broadcast['id'] ?? nomorUrut),
      background: _buildSwipeActionLeft(),
      secondaryBackground: _buildSwipeActionRight(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Geser ke kanan untuk Edit
          _editBroadcast(broadcast, context);
          return false; // Jangan hapus dari list
        } else if (direction == DismissDirection.endToStart) {
          // Geser ke kiri untuk Hapus
          _deleteBroadcast(broadcast, context);
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
            onTap: () => _showDetail(broadcast, context),
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
                            Expanded(
                              child: _buildInfoChip(
                                dibuatOleh,
                                Icons.group,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              tanggalPublikasi,
                              Icons.person,
                              Colors.grey,
                            ),
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

  void _editBroadcast(
    Map<String, dynamic> broadcast,
    BuildContext context,
  ) async {
    final model = Broadcast(
      id: broadcast['id'],
      judul: broadcast['judul'] ?? '',
      isiPesan: broadcast['isi_pesan'],
      tanggalPublikasi: broadcast['tanggal_publikasi'] != null
          ? DateTime.tryParse(broadcast['tanggal_publikasi'])
          : null,
      dibuatOleh: broadcast['dibuat_oleh'],
      lampiranGambar: broadcast['lampiran_gambar'],
      lampiranDokumen: broadcast['lampiran_dokumen'],
    );

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BroadcastFormPage(existing: model),
      ),
    );

    if (updated == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Broadcast berhasil diperbarui!')),
      );
    }
  }

  void _deleteBroadcast(
    Map<String, dynamic> broadcast,
    BuildContext context,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus broadcast ini?"),
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
      final id = broadcast['id'];
      if (id != null) {
        await context.read<BroadcastProvider>().remove(id as int);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Broadcast berhasil dihapus!')),
          );
        }
      }
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

  void _showDetail(Map<String, dynamic> broadcast, BuildContext context) {
    final model = Broadcast(
      id: broadcast['id'],
      judul: broadcast['judul'] ?? '',
      isiPesan: broadcast['isi_pesan'],
      tanggalPublikasi: broadcast['tanggal_publikasi'] != null
          ? DateTime.tryParse(broadcast['tanggal_publikasi'])
          : null,
      dibuatOleh: broadcast['dibuat_oleh'],
      lampiranGambar: broadcast['lampiran_gambar'],
      lampiranDokumen: broadcast['lampiran_dokumen'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BroadcastDetailPage(broadcast: model),
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
