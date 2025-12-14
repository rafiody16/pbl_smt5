import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/providers/auth_provider.dart';
import 'package:jawara_pintar_v2/sidebar/components/sidebar_menu.dart';
import 'package:provider/provider.dart';
import '../../blocs/rumah_bloc.dart';
import '../../models/rumah.dart';
import '../../sidebar/sidebar.dart'; // Pastikan path sidebar benar
import 'rumah_stream_form.dart';
import 'rumah_stream_detail_page.dart';

class RumahStreamPage extends StatefulWidget {
  const RumahStreamPage({Key? key}) : super(key: key);

  @override
  State<RumahStreamPage> createState() => _RumahStreamPageState();
}

class _RumahStreamPageState extends State<RumahStreamPage> {
  // Inisialisasi BLoC
  final RumahBloc _bloc = RumahBloc();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _confirmDelete(int id, String alamat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus data rumah di "$alamat"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _bloc.deleteRumah(id).catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil role melalui watch sekali di awal build
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.isAdmin;
    final isSekretaris = auth.isSekretaris;

    return Scaffold(
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SidebarMenu(userRole: authProvider.userRole);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          'Data Rumah',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<List<Rumah>>(
        stream: _bloc.rumahStream, // <--- Mendengarkan Stream di sini
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_work_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada data rumah',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final listRumah = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listRumah.length,
            itemBuilder: (context, index) {
              final rumah = listRumah[index];
              return _buildRumahCard(rumah);
            },
          );
        },
      ),
      floatingActionButton: isAdmin || isSekretaris
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RumahStreamForm(bloc: _bloc),
                  ),
                );
              },
              label: const Text('Tambah Rumah'),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }

  Widget _buildRumahCard(Rumah rumah) {
    // Jangan gunakan context.select di sini; gunakan nilai dari build()
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.isAdmin;
    final isSekretaris = auth.isSekretaris;

    Color statusColor = rumah.statusRumah == 'Ditempati'
        ? Colors.blue
        : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.home, color: Colors.blue),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RumahStreamDetailPage(
                rumah: rumah,
                bloc:
                    _bloc, // Kirim bloc agar detail page bisa listen stream juga
              ),
            ),
          );
        },
        title: Text(
          rumah.alamat,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('RT ${rumah.rt} / RW ${rumah.rw}'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip(rumah.statusRumah, statusColor),
                const SizedBox(width: 8),
                if (rumah.statusKepemilikan != null)
                  _buildChip(rumah.statusKepemilikan!, Colors.orange),
              ],
            ),
          ],
        ),
        trailing: isAdmin || isSekretaris
            ? PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RumahStreamForm(bloc: _bloc, existingRumah: rumah),
                      ),
                    );
                  } else if (value == 'delete') {
                    if (rumah.id != null)
                      _confirmDelete(rumah.id!, rumah.alamat);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
