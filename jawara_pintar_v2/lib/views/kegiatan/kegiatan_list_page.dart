import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../sidebar/sidebar.dart';
import '../../kegiatan/components/filter/filter_kegiatan.dart';
import '../../kegiatan/components/tabel_content.dart';
import '../../kegiatan/components/tabel_kegiatan.dart';
import '../../providers/kegiatan_provider.dart';
import '../../services/toast_service.dart';

class KegiatanListPage extends StatefulWidget {
  const KegiatanListPage({super.key});

  @override
  State<KegiatanListPage> createState() => _KegiatanListPageState();
}

class _KegiatanListPageState extends State<KegiatanListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<KegiatanProvider>().init());
  }

  void _showFilterDialog(BuildContext context) {
    final provider = context.read<KegiatanProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: FilterKegiatanDialog(
            onFilterApplied: provider.setFilters,
            onFilterReset: provider.clearFilters,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          'Data Kegiatan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          Consumer<KegiatanProvider>(
            builder: (_, p, __) => IconButton(
              icon: Icon(
                p.filters.isNotEmpty
                    ? Icons.filter_alt_rounded
                    : Icons.filter_alt_outlined,
              ),
              onPressed: () => _showFilterDialog(context),
              tooltip: 'Filter',
            ),
          ),
        ],
      ),
      drawer: const Sidebar(userEmail: 'admin@jawara.com'),
      body: Consumer<KegiatanProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gagal memuat data'),
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
          return RefreshIndicator(
            onRefresh: provider.fetch,
            child: Column(
              children: [
                if (provider.filters.isNotEmpty) _buildActiveFilters(provider),
                Expanded(
                  child: ListContent(
                    filteredData: provider.items
                        .map(
                          (k) => {
                            'id': k.id,
                            'nama': k.namaKegiatan,
                            'kategori': k.kategori,
                            'penanggungJawab': k.penanggungJawab,
                            'tanggal':
                                k.tanggalPelaksanaan
                                    ?.toIso8601String()
                                    .substring(0, 10) ??
                                '-',
                            'lokasi': k.lokasi,
                            'deskripsi': k.deskripsi,
                            'poster_url': k.posterUrl,
                          },
                        )
                        .toList(),
                    scrollController: _scrollController,
                    totalKegiatan: provider.items.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.pushNamed(context, '/kegiatan/form');
          if (created == true && mounted) {
            ToastService.showSuccess(context, 'Kegiatan berhasil disimpan');
          }
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  Widget _buildActiveFilters(KegiatanProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                  Icons.filter_alt,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              const Flexible(
                child: Text(
                  'Filter Aktif',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: provider.clearFilters,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.clear, size: 14, color: Colors.red[400]),
                      const SizedBox(width: 4),
                      Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.filters.entries.map((entry) {
              return Chip(
                label: Text(
                  '${entry.key}: ${entry.value}',
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue.withOpacity(0.1),
                deleteIcon: Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.blue[400],
                ),
                onDeleted: () {
                  final newFilters = Map<String, String>.from(provider.filters);
                  newFilters.remove(entry.key);
                  provider.setFilters(newFilters);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.blue.withOpacity(0.3)),
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
