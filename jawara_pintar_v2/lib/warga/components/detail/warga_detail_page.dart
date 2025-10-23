import 'package:flutter/material.dart';
import '../../../data/warga_data.dart';
import '../edit/warga_edit_page.dart';

class WargaDetailPage extends StatelessWidget {
  final Map<String, dynamic> warga;

  const WargaDetailPage({
    super.key,
    required this.warga,
  });

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

  void _editData(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WargaEditPage(warga: warga),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () => _editData(context),
            tooltip: 'Edit Data',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeaderSection(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildInfoSection(),
              _buildStatusSection(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warga['nama'] ?? '-',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  warga['nik'] ?? '-',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getKeluargaName(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                "Informasi Pribadi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Nama Lengkap', warga['nama'] ?? '-', Icons.person),
          _buildInfoItem('NIK', warga['nik'] ?? '-', Icons.badge),
          _buildInfoItem('Tempat Lahir', warga['tempat_lahir'] ?? '-', Icons.place),
          _buildInfoItem('Tanggal Lahir', warga['tanggal_lahir'] ?? '-', Icons.cake),
          _buildInfoItem('Jenis Kelamin', warga['jenis_kelamin'] ?? '-', Icons.transgender),
          _buildInfoItem('Agama', warga['agama'] ?? '-', Icons.psychology),
          _buildInfoItem('Golongan Darah', warga['golongan_darah'] ?? '-', Icons.bloodtype),
          _buildInfoItem('Pendidikan', warga['pendidikan'] ?? '-', Icons.school),
          _buildInfoItem('Pekerjaan', warga['pekerjaan'] ?? '-', Icons.work),
          _buildInfoItem('Peran Keluarga', warga['peran'] ?? '-', Icons.family_restroom),
          _buildInfoItem('No. Telepon', warga['no_telepon'] ?? '-', Icons.phone),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.fact_check_outlined, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                "Status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Status Domisili',
                  warga['status_domisili'] ?? '-',
                  _getStatusColor(warga['status_domisili'] ?? '-'),
                  Icons.home_work,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'Status Hidup',
                  warga['status_hidup'] ?? '-',
                  _getStatusColor(warga['status_hidup'] ?? '-'),
                  Icons.favorite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
      case 'hidup':
        return Colors.green;
      case 'tidak aktif':
      case 'meninggal':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}