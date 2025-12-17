import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/broadcast.dart';

class BroadcastDetailPage extends StatelessWidget {
  final Broadcast broadcast;
  const BroadcastDetailPage({super.key, required this.broadcast});

  String _fmt(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Broadcast'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        broadcast.judul,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _chip(
                      Icons.event,
                      _fmt(broadcast.tanggalPublikasi),
                      Colors.teal,
                    ),
                    const SizedBox(width: 8),
                    _chip(
                      Icons.person,
                      broadcast.dibuatOleh ?? '-',
                      Colors.indigo,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Isi Pesan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  broadcast.isiPesan?.isNotEmpty == true
                      ? broadcast.isiPesan!
                      : 'Tidak ada isi pesan.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lampiran',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text('Gambar: ${broadcast.lampiranGambar ?? '-'}'),
                Text('Dokumen: ${broadcast.lampiranDokumen ?? '-'}'),
              ],
            ),
          ),
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
