import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/kegiatan.dart';
import '../../providers/kegiatan_provider.dart';
import '../../services/toast_service.dart';
import 'kegiatan_form_page.dart';

class KegiatanDetailPage extends StatelessWidget {
  final Kegiatan kegiatan;
  const KegiatanDetailPage({super.key, required this.kegiatan});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kegiatan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KegiatanFormPage(existing: kegiatan),
                ),
              );
              if (result == true) {
                ToastService.showSuccess(context, 'Perubahan disimpan');
                // Kembali ke list; realtime akan memperbarui tampilan
                if (Navigator.canPop(context)) Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final id = kegiatan.id;
              if (id == null) return;
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Kegiatan'),
                  content: Text(
                    'Yakin ingin menghapus "${kegiatan.namaKegiatan}"?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                try {
                  await context.read<KegiatanProvider>().remove(id);
                  ToastService.showSuccess(context, 'Kegiatan dihapus');
                  if (Navigator.canPop(context)) Navigator.pop(context, true);
                } catch (e) {
                  ToastService.showError(context, e.toString());
                }
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildInfoCards(),
            const SizedBox(height: 16),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.event, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kegiatan.namaKegiatan,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(
                        Icons.category,
                        kegiatan.kategori ?? 'Tidak ada kategori',
                        Colors.indigo,
                      ),
                      _chip(
                        Icons.calendar_today,
                        _formatDate(kegiatan.tanggalPelaksanaan),
                        Colors.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _infoTile(
            title: 'Lokasi',
            value: kegiatan.lokasi ?? '-',
            icon: Icons.place_outlined,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _infoTile(
            title: 'Penanggung Jawab',
            value: kegiatan.penanggungJawab ?? '-',
            icon: Icons.badge_outlined,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.notes, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Deskripsi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              (kegiatan.deskripsi?.isNotEmpty ?? false)
                  ? kegiatan.deskripsi!
                  : 'Tidak ada deskripsi.',
              style: const TextStyle(color: Colors.black87, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
