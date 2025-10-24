import 'package:flutter/material.dart';
import '../../../model/chanel_transfer.dart';

class DetailChanelCard extends StatelessWidget {
  final ChanelTransfer chanel;

  const DetailChanelCard({super.key, required this.chanel});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Nama Channel', chanel.nama),
            _buildDetailRow('Tipe Channel', chanel.tipe.toUpperCase()),
            _buildDetailRow('Nomor Rekening / Akun', chanel.nomorAkun),
            _buildDetailRow('Nama Pemilik', chanel.namaPemilik),
            if (chanel.catatan != null && chanel.catatan!.isNotEmpty)
              _buildDetailRow('Catatan', chanel.catatan!),
            // Di sini Anda bisa menambahkan logic untuk menampilkan QR/Thumbnail
          ],
        ),
      ),
    );
  }
}