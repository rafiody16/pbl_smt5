import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/providers/auth_provider.dart';
import '../../blocs/rumah_bloc.dart';
import '../../models/rumah.dart';
import 'rumah_stream_form.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/components/sidebar_menu.dart';
import '../../sidebar/sidebar.dart';

class RumahStreamDetailPage extends StatelessWidget {
  final Rumah rumah;
  final RumahBloc bloc;

  const RumahStreamDetailPage({
    Key? key,
    required this.rumah,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil role menggunakan watch di dalam build
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.isAdmin;
    final isSekretaris = auth.isSekretaris;
    // Kita gunakan StreamBuilder khusus untuk satu item ini agar update realtime
    // jika diedit di halaman lain (opsional, tapi bagus untuk konsistensi stream)
    return StreamBuilder<List<Rumah>>(
      stream: bloc.rumahStream,
      builder: (context, snapshot) {
        // Cari data terbaru dari stream berdasarkan ID
        // Jika tidak ketemu (misal dihapus), pakai data lama (rumah)
        final currentRumah = snapshot.hasData
            ? snapshot.data!.firstWhere(
                (element) => element.id == rumah.id,
                orElse: () => rumah,
              )
            : rumah;

        return Scaffold(
          drawer: Drawer(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return SidebarMenu(userRole: authProvider.userRole);
              },
            ),
          ),
          backgroundColor: const Color(0xFFF8FAFF),
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, currentRumah),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildInfoSection(currentRumah),
                  _buildStatusSection(currentRumah),
                  const SizedBox(height: 30),
                ]),
              ),
            ],
          ),
          floatingActionButton: isAdmin || isSekretaris
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RumahStreamForm(
                          bloc: bloc,
                          existingRumah: currentRumah,
                        ),
                      ),
                    );
                  },
                  label: const Text('Edit Data'),
                  icon: const Icon(Icons.edit),
                  backgroundColor: Colors.orange,
                )
              : null,
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Rumah rumah) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF667EEA),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  rumah.alamat,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "RT ${rumah.rt} / RW ${rumah.rw}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Rumah rumah) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Informasi Fisik",
            Icons.info_outline,
            Colors.blue,
          ),
          const SizedBox(height: 20),
          _buildInfoRow("Luas Tanah", "${rumah.luasTanah ?? '-'} m²"),
          const Divider(height: 24),
          _buildInfoRow("Luas Bangunan", "${rumah.luasBangunan ?? '-'} m²"),
          const Divider(height: 24),
          _buildInfoRow(
            "Jumlah Penghuni",
            "${rumah.jumlahPenghuni ?? 0} Orang",
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(Rumah rumah) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            "Status Rumah",
            Icons.verified_user_outlined,
            Colors.green,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  "Status Hunian",
                  rumah.statusRumah,
                  rumah.statusRumah == 'Ditempati' ? Colors.blue : Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatusCard(
                  "Kepemilikan",
                  rumah.statusKepemilikan ?? '-',
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
