import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/warga_provider.dart';
import '../../../models/warga.dart';
import '../../../sidebar/sidebar.dart';

class WargaDetailPage extends StatelessWidget {
  const WargaDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final warga = ModalRoute.of(context)?.settings.arguments as Warga?;

    if (warga == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Warga')),
        body: const Center(child: Text('Data warga tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Warga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/warga/edit', arguments: warga);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, warga),
          ),
        ],
      ),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan foto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: warga.fotoUrl != null
                        ? ClipOval(
                            child: Image.network(
                              warga.fotoUrl!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildInitialAvatar(warga.namaLengkap);
                              },
                            ),
                          )
                        : _buildInitialAvatar(warga.namaLengkap),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    warga.namaLengkap,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NIK: ${warga.nik}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Data detail
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Informasi Pribadi'),
                  _buildDetailCard([
                    _buildDetailRow(
                      Icons.wc,
                      'Jenis Kelamin',
                      warga.jenisKelamin ?? '-',
                    ),
                    _buildDetailRow(
                      Icons.location_city,
                      'Tempat Lahir',
                      warga.tempatLahir ?? '-',
                    ),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Tanggal Lahir',
                      warga.tanggalLahir != null
                          ? '${warga.tanggalLahir!.day}/${warga.tanggalLahir!.month}/${warga.tanggalLahir!.year}'
                          : '-',
                    ),
                    _buildDetailRow(Icons.church, 'Agama', warga.agama ?? '-'),
                    _buildDetailRow(
                      Icons.bloodtype,
                      'Golongan Darah',
                      warga.golonganDarah ?? '-',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Kontak'),
                  _buildDetailCard([
                    _buildDetailRow(Icons.email, 'Email', warga.email ?? '-'),
                    _buildDetailRow(
                      Icons.phone,
                      'No Telepon',
                      warga.noTelepon ?? '-',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Pendidikan & Pekerjaan'),
                  _buildDetailCard([
                    _buildDetailRow(
                      Icons.school,
                      'Pendidikan Terakhir',
                      warga.pendidikanTerakhir ?? '-',
                    ),
                    _buildDetailRow(
                      Icons.work,
                      'Pekerjaan',
                      warga.pekerjaan ?? '-',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Status'),
                  _buildDetailCard([
                    _buildDetailRow(
                      Icons.home,
                      'Status Domisili',
                      warga.statusDomisili,
                    ),
                    _buildDetailRow(
                      Icons.health_and_safety,
                      'Status Hidup',
                      warga.statusHidup,
                    ),
                    _buildDetailRow(
                      Icons.family_restroom,
                      'Peran dalam Keluarga',
                      warga.peran ?? '-',
                    ),
                  ]),
                  if (warga.keluargaId != null) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('Keluarga'),
                    _buildDetailCard([
                      _buildDetailRow(
                        Icons.groups,
                        'Nama Keluarga',
                        warga.keluargaId?.toString() ?? '-',
                      ),
                    ]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Text(
      initial,
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Warga warga) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Warga'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${warga.namaLengkap}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = context.read<WargaProvider>();
              final success = await provider.deleteWarga(warga.nik);

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data warga berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.errorMessage ?? 'Terjadi kesalahan',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
