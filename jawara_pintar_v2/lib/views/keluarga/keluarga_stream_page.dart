import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/providers/auth_provider.dart';
import '../../blocs/keluarga_bloc.dart';
import '../../models/keluarga_model.dart';
import '../../sidebar/sidebar.dart';
import 'keluarga_stream_form.dart';
import 'keluarga_stream_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/components/sidebar_menu.dart';

class KeluargaStreamPage extends StatefulWidget {
  const KeluargaStreamPage({Key? key}) : super(key: key);

  @override
  State<KeluargaStreamPage> createState() => _KeluargaStreamPageState();
}

class _KeluargaStreamPageState extends State<KeluargaStreamPage> {
  final KeluargaBloc _bloc = KeluargaBloc();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _confirmDelete(int id, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus data keluarga "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _bloc.deleteKeluarga(id).catchError((e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
          'Data Keluarga',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<List<KeluargaModel>>(
        stream: _bloc.keluargaStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data keluarga'));
          }

          final listKeluarga = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listKeluarga.length,
            itemBuilder: (context, index) {
              final keluarga = listKeluarga[index];
              return _buildKeluargaCard(keluarga);
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
                    builder: (context) => KeluargaStreamForm(bloc: _bloc),
                  ),
                );
              },
              label: const Text('Tambah Keluarga'),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }

  Widget _buildKeluargaCard(KeluargaModel keluarga) {
    Color statusColor = keluarga.status == 'Aktif' ? Colors.green : Colors.grey;
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.isAdmin;
    final isSekretaris = auth.isSekretaris;

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
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Text(
            keluarga.namaKeluarga.isNotEmpty
                ? keluarga.namaKeluarga[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          keluarga.namaKeluarga,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Kepala: ${keluarga.kepalaKeluarga ?? '-'}'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip(keluarga.status, statusColor),
                const SizedBox(width: 8),
                _buildChip(
                  '${keluarga.jumlahAnggota ?? 0} Anggota',
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
        trailing: (isAdmin || isSekretaris)
            ? PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KeluargaStreamForm(
                          bloc: _bloc,
                          existingKeluarga: keluarga,
                        ),
                      ),
                    );
                  } else if (value == 'delete') {
                    if (keluarga.id != null)
                      _confirmDelete(keluarga.id!, keluarga.namaKeluarga);
                  } else if (value == 'detail') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KeluargaStreamDetailPage(
                          keluarga: keluarga,
                          bloc: _bloc,
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'detail',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 20),
                        SizedBox(width: 8),
                        Text('Detail'),
                      ],
                    ),
                  ),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  KeluargaStreamDetailPage(keluarga: keluarga, bloc: _bloc),
            ),
          );
        },
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
