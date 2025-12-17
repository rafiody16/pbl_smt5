import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/warga.dart';
import '../../../providers/warga_provider.dart';
import '../../../sidebar/sidebar.dart';
import 'pengguna_detail_page.dart';

class PenggunaListPage extends StatefulWidget {
  const PenggunaListPage({super.key});

  @override
  State<PenggunaListPage> createState() => _PenggunaListPageState();
}

class _PenggunaListPageState extends State<PenggunaListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WargaProvider>().loadWarga();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Manajemen Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Consumer<WargaProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter hanya warga yang punya akun (user_id tidak null)
          final penggunaList = provider.wargaList
              .where((w) => w.userId != null && w.userId!.isNotEmpty)
              .toList();

          if (penggunaList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pengguna terdaftar',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tekan tombol + untuk menambah pengguna',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadWarga(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: penggunaList.length,
              itemBuilder: (context, index) {
                final pengguna = penggunaList[index];
                return _buildPenggunaCard(context, pengguna);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/pengguna/add');
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah Pengguna'),
      ),
    );
  }

  Widget _buildPenggunaCard(BuildContext context, Warga pengguna) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PenggunaDetailPage(pengguna: pengguna),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: _getRoleColor(pengguna.role).withOpacity(0.2),
                child: Text(
                  pengguna.namaLengkap[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getRoleColor(pengguna.role),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengguna.namaLengkap,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pengguna.email ?? 'Email tidak tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(pengguna.role).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getRoleColor(pengguna.role).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _getRoleLabel(pengguna.role),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getRoleColor(pengguna.role),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'detail') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PenggunaDetailPage(pengguna: pengguna),
                      ),
                    );
                  } else if (value == 'edit') {
                    Navigator.pushNamed(
                      context,
                      '/pengguna/edit',
                      arguments: pengguna,
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'detail',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 20),
                        SizedBox(width: 12),
                        Text('Detail'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Edit'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
