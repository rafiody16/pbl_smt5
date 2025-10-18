import 'package:flutter/material.dart';
import '../../../data/warga_data.dart';

class KeluargaDetailPage extends StatelessWidget {
  final Map<String, dynamic> keluarga;

  const KeluargaDetailPage({
    super.key,
    required this.keluarga,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil data anggota keluarga dari field 'anggota'
    List<Map<String, dynamic>> anggotaKeluarga = (keluarga['anggota'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Keluarga",
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
            // Header dengan nama keluarga
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Keluarga ${keluarga['nama_keluarga']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Status: ${keluarga['status']}",
                    style: TextStyle(
                      fontSize: 14,
                      color: keluarga['status'] == 'Aktif' 
                          ? Colors.green 
                          : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Informasi Keluarga
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informasi Keluarga",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 16),

                    _buildDetailItem('Nama Keluarga:', keluarga['nama_keluarga']),
                    _buildDetailItem('Kepala Keluarga:', keluarga['kepala_keluarga']),
                    _buildDetailItem('Rumah Saat Ini:', keluarga['alamat']),
                    _buildDetailItem('RT/RW:', '${keluarga['rt']}/${keluarga['rw']}'),
                    _buildDetailItem('No. Telepon:', keluarga['no_telepon']),
                    _buildDetailItem('Jumlah Anggota:', '${keluarga['jumlah_anggota']} orang'),
                    _buildDetailItem('Status Kepemilikan:', keluarga['status_kepemilikan']),
                    _buildDetailItem('Status Keluarga:', keluarga['status']),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Anggota Keluarga Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Anggota Keluarga",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            anggotaKeluarga.length.toString(),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (anggotaKeluarga.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Tidak ada anggota keluarga",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      ...anggotaKeluarga.map((anggota) => 
                        _buildAnggotaKeluarga(
                          nama: anggota['nama'],
                          nik: anggota['nik'],
                          peran: anggota['peran'],
                          jenisKelamin: anggota['jenis_kelamin'],
                          status: anggota['status_domisili'],
                          tanggalLahir: anggota['tanggal_lahir'],
                        )
                      ).toList(),
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
              width: 150,
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

  Widget _buildAnggotaKeluarga({
    required String nama,
    required String nik,
    required String peran,
    required String jenisKelamin,
    required String status,
    required String tanggalLahir,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nama,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildAnggotaDetailItem('NIK:', nik),
          _buildAnggotaDetailItem('Peran:', peran),
          _buildAnggotaDetailItem('Jenis Kelamin:', jenisKelamin),
          _buildAnggotaDetailItem('Tanggal Lahir:', tanggalLahir),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'Aktif' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: status == 'Aktif' ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Aktif' ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnggotaDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}