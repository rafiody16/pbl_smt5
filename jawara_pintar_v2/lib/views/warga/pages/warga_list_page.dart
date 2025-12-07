import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/warga_provider.dart';
import '../widgets/warga_card.dart';
import '../widgets/common_widgets.dart' as common_widgets;
import '../widgets/filter_dialog.dart';
import '../../../sidebar/sidebar.dart';

class WargaListPage extends StatefulWidget {
  const WargaListPage({Key? key}) : super(key: key);

  @override
  State<WargaListPage> createState() => _WargaListPageState();
}

class _WargaListPageState extends State<WargaListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WargaProvider>();
      provider.loadWarga();
      provider.loadKeluarga();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() async {
    final provider = context.read<WargaProvider>();
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => FilterWargaDialog(initialFilters: provider.filters),
    );

    if (result != null) {
      provider.applyFilters(result);
    }
  }

  void _confirmDelete(BuildContext context, String nik, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus data warga "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<WargaProvider>();
              final success = await provider.deleteWarga(nik);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Data warga berhasil dihapus'
                          : 'Gagal menghapus data warga',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Warga'),
        actions: [
          Consumer<WargaProvider>(
            builder: (context, provider, _) {
              if (provider.filters.isNotEmpty) {
                return IconButton(
                  icon: const Badge(child: Icon(Icons.filter_list)),
                  onPressed: _showFilterDialog,
                  tooltip: 'Filter',
                );
              }
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
                tooltip: 'Filter',
              );
            },
          ),
        ],
      ),
      drawer: const Sidebar(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari warga...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<WargaProvider>().loadWarga();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<WargaProvider>().searchWarga(value);
                } else {
                  context.read<WargaProvider>().loadWarga();
                }
              },
            ),
          ),
          // Active Filters
          Consumer<WargaProvider>(
            builder: (context, provider, _) {
              if (provider.filters.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...provider.filters.entries.map((entry) {
                      if (entry.value.isEmpty) return const SizedBox.shrink();

                      return Chip(
                        label: Text('${entry.key}: ${entry.value}'),
                        onDeleted: () {
                          final newFilters = Map<String, String>.from(
                            provider.filters,
                          );
                          newFilters.remove(entry.key);
                          provider.applyFilters(newFilters);
                        },
                      );
                    }).toList(),
                    if (provider.filters.isNotEmpty)
                      ActionChip(
                        label: const Text('Hapus Semua'),
                        onPressed: () => provider.clearFilters(),
                        avatar: const Icon(Icons.clear, size: 16),
                      ),
                  ],
                ),
              );
            },
          ),
          // Content
          Expanded(
            child: Consumer<WargaProvider>(
              builder: (context, provider, _) {
                // Loading state
                if (provider.isLoading) {
                  return const common_widgets.LoadingWidget(
                    message: 'Memuat data warga...',
                  );
                }

                // Error state
                if (provider.errorMessage != null) {
                  return common_widgets.ErrorWidget(
                    message: provider.errorMessage!,
                    onRetry: () {
                      provider.clearError();
                      provider.loadWarga();
                      provider.loadKeluarga();
                    },
                  );
                }

                // Empty state
                final wargaList = provider.filteredWargaList;
                if (wargaList.isEmpty) {
                  return common_widgets.EmptyStateWidget(
                    message: provider.filters.isNotEmpty
                        ? 'Tidak ada warga yang sesuai dengan filter'
                        : 'Belum ada data warga',
                    icon: Icons.people_outline,
                    actionLabel: 'Tambah Warga',
                    onActionPressed: () {
                      Navigator.pushNamed(context, '/warga/add');
                    },
                  );
                }

                // List of warga
                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.loadWarga();
                    await provider.loadKeluarga();
                  },
                  child: ListView.builder(
                    itemCount: wargaList.length,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      final warga = wargaList[index];
                      final keluargaName = provider.getKeluargaName(
                        warga.keluargaId,
                      );

                      return WargaCard(
                        warga: warga,
                        keluargaName: keluargaName,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/warga/detail',
                            arguments: warga,
                          );
                        },
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            '/warga/edit',
                            arguments: warga,
                          );
                        },
                        onDelete: () {
                          _confirmDelete(context, warga.nik, warga.namaLengkap);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/warga/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Warga'),
      ),
    );
  }
}
