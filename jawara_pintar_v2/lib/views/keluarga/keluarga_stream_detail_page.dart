import 'package:flutter/material.dart';
import '../../blocs/keluarga_bloc.dart';
import '../../models/keluarga_model.dart';
import 'keluarga_stream_form.dart';

class KeluargaStreamDetailPage extends StatelessWidget {
  final KeluargaModel keluarga;
  final KeluargaBloc bloc;

  const KeluargaStreamDetailPage({
    Key? key,
    required this.keluarga,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<KeluargaModel>>(
      stream: bloc.keluargaStream,
      builder: (context, snapshot) {
        final currentKeluarga = snapshot.hasData
            ? snapshot.data!.firstWhere(
                (e) => e.id == keluarga.id,
                orElse: () => keluarga,
              )
            : keluarga;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, currentKeluarga),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildInfoSection(
                    context,
                    currentKeluarga,
                  ), // Pass context for FutureBuilder
                  _buildStatusSection(currentKeluarga),
                  const SizedBox(height: 30),
                ]),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KeluargaStreamForm(
                    bloc: bloc,
                    existingKeluarga: currentKeluarga,
                  ),
                ),
              );
            },
            label: const Text('Edit Data'),
            icon: const Icon(Icons.edit),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, KeluargaModel keluarga) {
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
                  Icons.family_restroom,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  keluarga.namaKeluarga,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, KeluargaModel keluarga) {
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
            "Informasi Dasar",
            Icons.info_outline,
            Colors.blue,
          ),
          const SizedBox(height: 20),
          _buildInfoRow("Kepala Keluarga", keluarga.kepalaKeluarga ?? '-'),
          const Divider(height: 24),
          _buildInfoRow(
            "Jumlah Anggota",
            "${keluarga.jumlahAnggota ?? 0} Orang",
          ),
          const Divider(height: 24),

          // FutureBuilder untuk mengambil nama rumah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Lokasi Rumah",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              FutureBuilder<String>(
                future: bloc.getNamaRumah(keluarga.rumahId),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? 'Memuat...',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(KeluargaModel keluarga) {
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
            "Status",
            Icons.verified_user_outlined,
            Colors.green,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  "Status Data",
                  keluarga.status,
                  keluarga.status == 'Aktif' ? Colors.green : Colors.red,
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
