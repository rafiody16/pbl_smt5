import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/sidebar/components/sidebar_menu.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/warga_provider.dart';
import '../../../models/warga.dart';
import '../../../warga/components/shared/status_chip.dart';
import '../../../providers/auth_provider.dart';

class WargaDetailPage extends StatelessWidget {
  const WargaDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.select<AuthProvider, bool>((auth) => auth.isAdmin);
    final isSekretaris = context.select<AuthProvider, bool>(
      (auth) => auth.isSekretaris,
    );
    final warga = ModalRoute.of(context)?.settings.arguments as Warga?;

    if (warga == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Warga')),
        body: const Center(child: Text('Data warga tidak ditemukan')),
      );
    }

    return Scaffold(
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SidebarMenu(userRole: authProvider.userRole);
          },
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Warga",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (isAdmin || isSekretaris)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: () {
                Navigator.pushNamed(context, '/warga/edit', arguments: warga);
              },
              tooltip: 'Edit Data',
            ),
          if (isAdmin || isSekretaris)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, warga),
              tooltip: 'Hapus Data',
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeaderSection(context, warga)),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildInfoSection(warga),
              _buildStatusSection(warga),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, Warga warga) {
    // Ambil nama keluarga dari provider
    final keluargaName = context.read<WargaProvider>().getKeluargaName(
      warga.keluargaId,
    );

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
              image: warga.fotoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(warga.fotoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: warga.fotoUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 32)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warga.namaLengkap,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  warga.nik,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    keluargaName,
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

  Widget _buildInfoSection(Warga warga) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final tglLahir = warga.tanggalLahir != null
        ? dateFormat.format(warga.tanggalLahir!)
        : '-';

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
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.blue,
                  size: 20,
                ),
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
          _buildInfoItem('Nama Lengkap', warga.namaLengkap, Icons.person),
          _buildInfoItem('NIK', warga.nik, Icons.badge),
          _buildInfoItem('Tempat Lahir', warga.tempatLahir ?? '-', Icons.place),
          _buildInfoItem('Tanggal Lahir', tglLahir, Icons.cake),
          _buildInfoItem(
            'Jenis Kelamin',
            warga.jenisKelamin ?? '-',
            Icons.transgender,
          ),
          _buildInfoItem('Agama', warga.agama ?? '-', Icons.psychology),
          _buildInfoItem(
            'Golongan Darah',
            warga.golonganDarah ?? '-',
            Icons.bloodtype,
          ),
          _buildInfoItem(
            'Pendidikan',
            warga.pendidikanTerakhir ?? '-',
            Icons.school,
          ),
          _buildInfoItem('Pekerjaan', warga.pekerjaan ?? '-', Icons.work),
          _buildInfoItem(
            'Peran Keluarga',
            warga.peran ?? '-',
            Icons.family_restroom,
          ),
          _buildInfoItem('No. Telepon', warga.noTelepon ?? '-', Icons.phone),
          _buildInfoItem('Email', warga.email ?? '-', Icons.email),
        ],
      ),
    );
  }

  Widget _buildStatusSection(Warga warga) {
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
                child: const Icon(
                  Icons.fact_check_outlined,
                  color: Colors.green,
                  size: 20,
                ),
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
                  warga.statusDomisili,
                  _getStatusColor(warga.statusDomisili),
                  Icons.home_work,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'Status Hidup',
                  warga.statusHidup,
                  _getStatusColor(warga.statusHidup),
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

  Widget _buildStatusCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
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
      case 'tetap':
        return Colors.green;
      case 'tidak aktif':
      case 'meninggal':
        return Colors.red;
      case 'sementara':
      case 'kontrak':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  static void _showDeleteDialog(BuildContext context, Warga warga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data warga "${warga.namaLengkap}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
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
                  Navigator.pop(context); // Back to list page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.errorMessage ?? 'Gagal menghapus data warga',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
