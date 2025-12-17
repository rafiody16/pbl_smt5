import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../sidebar/sidebar.dart';
import '../../providers/broadcast_provider.dart';
import '../../services/toast_service.dart';
import '../../broadcast/components/tabel_content.dart';

class BroadcastListPage extends StatefulWidget {
  const BroadcastListPage({super.key});

  @override
  State<BroadcastListPage> createState() => _BroadcastListPageState();
}

class _BroadcastListPageState extends State<BroadcastListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BroadcastProvider>().init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          'Data Broadcast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      drawer: const Sidebar(userEmail: 'admin@jawara.com'),
      body: Consumer<BroadcastProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat data'),
                  const SizedBox(height: 8),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.fetch,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final mapped = provider.items
              .map(
                (b) => {
                  'id': b.id,
                  'judul': b.judul,
                  'isi_pesan': b.isiPesan,
                  'tanggal_publikasi': b.tanggalPublikasi
                      ?.toIso8601String()
                      .substring(0, 10),
                  'dibuat_oleh': b.dibuatOleh,
                  'lampiran_gambar': b.lampiranGambar,
                  'lampiran_dokumen': b.lampiranDokumen,
                },
              )
              .toList();
          return RefreshIndicator(
            onRefresh: provider.fetch,
            child: ListContent(
              filteredData: mapped,
              scrollController: _scrollController,
              totalBroadcast: mapped.length,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.pushNamed(context, '/broadcast/form');
          if (created == true && mounted) {
            ToastService.showSuccess(context, 'Broadcast berhasil disimpan');
          }
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
