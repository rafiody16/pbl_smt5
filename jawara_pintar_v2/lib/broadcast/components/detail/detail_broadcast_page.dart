import 'package:flutter/material.dart';

class BroadcastDetailPage extends StatelessWidget {
  final Map<String, dynamic> broadcast;

  const BroadcastDetailPage({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Broadcast",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header icon + title
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Detail Broadcast",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 24),

                _buildDetailItem('Judul:', broadcast['judul'] ?? '-'),
                _buildDetailItem('Isi Pesan:', broadcast['isi_pesan'] ?? '-'),
                _buildDetailItem(
                  'Tanggal Publikasi:',
                  broadcast['tanggal_publikasi'] ?? '-',
                ),
                _buildDetailItem(
                  'Dibuat oleh:',
                  broadcast['dibuat_oleh'] ?? '-',
                ),

                const SizedBox(height: 24),
                const Text(
                  'Lampiran Gambar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildImageAttachment(context),

                const SizedBox(height: 24),
                const Text(
                  'Lampiran Dokumen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFileAttachment(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 160,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : '-',
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageAttachment(BuildContext context) {
    final gambar = broadcast['lampiran_gambar'];
    if (gambar == null || gambar.isEmpty) {
      return const Text(
        'Tidak ada lampiran gambar',
        style: TextStyle(color: Colors.black54),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'images/$gambar',
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 160,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const Text('Gambar tidak ditemukan'),
          );
        },
      ),
    );
  }

  Widget _buildFileAttachment(BuildContext context) {
    final dokumen = broadcast['lampiran_dokumen'];
    if (dokumen == null || dokumen.isEmpty) {
      return const Text(
        'Tidak ada lampiran dokumen',
        style: TextStyle(color: Colors.black54),
      );
    }

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Membuka dokumen $dokumen')));
      },
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            dokumen,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
