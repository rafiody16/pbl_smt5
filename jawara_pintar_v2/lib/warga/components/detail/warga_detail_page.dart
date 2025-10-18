import 'package:flutter/material.dart';
import '../../../data/warga_data.dart';

class WargaDetailPage extends StatelessWidget {
  final Map<String, dynamic> warga;

  const WargaDetailPage({
    super.key,
    required this.warga,
  });

  // Method untuk mendapatkan nama keluarga dari warga
  String _getKeluargaName() {
    for (var keluarga in WargaData.dataKeluarga) {
      var anggota = keluarga['anggota'] as List;
      var found = anggota.cast<Map<String, dynamic>>().firstWhere(
        (anggota) => anggota['nik'] == warga['nik'],
        orElse: () => <String, dynamic>{},
      );
      if (found.isNotEmpty) {
        return keluarga['nama_keluarga'] as String;
      }
    }
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Warga",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.person, color: Colors.blue, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Detail Warga",
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

                    _buildDetailItem('Nama Lengkap:', warga['nama'] ?? '-'),
                    _buildDetailItem('NIK:', warga['nik'] ?? '-'),
                    _buildDetailItem('Tempat, Tanggal Lahir:', 
                      '${warga['tempat_lahir'] ?? '-'}, ${warga['tanggal_lahir'] ?? '-'}'),
                    _buildDetailItem('Nomor telepon:', warga['no_telepon'] ?? '-'),
                    _buildDetailItem('Jenis Kelamin:', warga['jenis_kelamin'] ?? '-'),
                    _buildDetailItem('Agama:', warga['agama'] ?? '-'),
                    _buildDetailItem('Golongan Darah:', warga['golongan_darah'] ?? '-'),
                    _buildDetailItem('Pendidikan Terakhir:', warga['pendidikan'] ?? '-'),
                    _buildDetailItem('Pekerjaan:', warga['pekerjaan'] ?? '-'),
                    _buildDetailItem('Peran dalam Keluarga:', warga['peran'] ?? '-'),
                    _buildDetailItem('Status Domisili:', warga['status_domisili'] ?? '-'),
                    _buildDetailItem('Status Hidup:', warga['status_hidup'] ?? '-'),
                    _buildDetailItem('Keluarga:', _getKeluargaName()), // Gunakan method helper
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 180,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : '-',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}