import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/warga.dart';

class PenggunaDetailPage extends StatelessWidget {
  final Warga pengguna;

  const PenggunaDetailPage({super.key, required this.pengguna});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengguna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/pengguna/edit',
                arguments: pengguna,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card dengan Avatar
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getRoleColor(pengguna.role),
                    _getRoleColor(pengguna.role).withOpacity(0.7),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          pengguna.namaLengkap[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: _getRoleColor(pengguna.role),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        pengguna.namaLengkap,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          _getRoleLabel(pengguna.role),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Detail Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Informasi Akun'),
                  _buildInfoCard([
                    _buildInfoRow(Icons.badge, 'NIK', pengguna.nik),
                    _buildInfoRow(
                      Icons.email,
                      'Email',
                      pengguna.email ?? 'Tidak ada',
                    ),
                    _buildInfoRow(
                      Icons.phone,
                      'No. Telepon',
                      pengguna.noTelepon ?? 'Tidak ada',
                    ),
                    _buildInfoRow(
                      Icons.admin_panel_settings,
                      'Role Sistem',
                      _getRoleLabel(pengguna.role),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Data Pribadi'),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.person,
                      'Jenis Kelamin',
                      pengguna.jenisKelamin ?? 'Tidak ada',
                    ),
                    _buildInfoRow(
                      Icons.cake,
                      'Tanggal Lahir',
                      pengguna.tanggalLahir != null
                          ? DateFormat(
                              'dd MMMM yyyy',
                              'id_ID',
                            ).format(pengguna.tanggalLahir!)
                          : 'Tidak ada',
                    ),
                    _buildInfoRow(
                      Icons.place,
                      'Tempat Lahir',
                      pengguna.tempatLahir ?? 'Tidak ada',
                    ),
                    _buildInfoRow(
                      Icons.church,
                      'Agama',
                      pengguna.agama ?? 'Tidak ada',
                    ),
                    _buildInfoRow(
                      Icons.bloodtype,
                      'Golongan Darah',
                      pengguna.golonganDarah ?? 'Tidak ada',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Data Pekerjaan & Pendidikan'),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.school,
                      'Pendidikan Terakhir',
                      pengguna.pendidikanTerakhir ?? 'Tidak ada',
                    ),
                    _buildInfoRow(
                      Icons.work,
                      'Pekerjaan',
                      pengguna.pekerjaan ?? 'Tidak ada',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Status'),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.home,
                      'Status Domisili',
                      pengguna.statusDomisili,
                    ),
                    _buildInfoRow(
                      Icons.favorite,
                      'Status Hidup',
                      pengguna.statusHidup,
                    ),
                    _buildInfoRow(
                      Icons.family_restroom,
                      'Peran dalam Keluarga',
                      pengguna.peran ?? 'Tidak ada',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Informasi Sistem'),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.fingerprint,
                      'User ID',
                      pengguna.userId ?? 'Tidak ada',
                      isMonospace: true,
                    ),
                    _buildInfoRow(
                      Icons.access_time,
                      'Terdaftar Sejak',
                      DateFormat(
                        'dd MMMM yyyy HH:mm',
                        'id_ID',
                      ).format(pengguna.createdAt),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isMonospace = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: isMonospace ? 'monospace' : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'bendahara':
        return 'Bendahara';
      case 'sekretaris':
        return 'Sekretaris';
      case 'ketua_rt':
        return 'Ketua RT';
      case 'ketua_rw':
        return 'Ketua RW';
      case 'warga':
        return 'Warga';
      default:
        return role;
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'bendahara':
        return Colors.green;
      case 'sekretaris':
        return Colors.blue;
      case 'ketua_rt':
        return Colors.purple;
      case 'ketua_rw':
        return Colors.orange;
      case 'warga':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
