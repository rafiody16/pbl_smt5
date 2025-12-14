import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/warga_provider.dart';
import '../widgets/warga_card.dart';
import '../widgets/common_widgets.dart' as common_widgets;
import '../widgets/filter_dialog.dart';
import 'package:jawara_pintar_v2/sidebar/components/sidebar_menu.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

class WargaListPage extends StatefulWidget {
  const WargaListPage({Key? key}) : super(key: key);

  @override
  State<WargaListPage> createState() => _WargaListPageState();
}

class _WargaListPageState extends State<WargaListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WargaProvider>();
      provider.loadWarga();
      provider.loadKeluarga();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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

  // ... (Kode _confirmDelete tetap sama) ...
  void _confirmDelete(BuildContext context, String nik, String nama) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus data warga "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final provider = context.read<WargaProvider>();

              // Hapus dan tunggu respons
              final success = await provider.deleteWarga(nik);

              if (mounted) {
                // Gunakan context dari page (outer scope), bukan dialogContext
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Data warga berhasil dihapus'
                          : (provider.errorMessage ??
                                'Gagal menghapus data warga'),
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                    duration: const Duration(seconds: 2),
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
    final isAdmin = context.select<AuthProvider, bool>((auth) => auth.isAdmin);
    final isSekretaris = context.select<AuthProvider, bool>(
      (auth) => auth.isSekretaris,
    );
    return Scaffold(
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SidebarMenu(userRole: authProvider.userRole);
          },
        ),
      ),
      backgroundColor: const Color(
        0xFFF8FAFF,
      ), // Warna background sesuai desain lama
      appBar: AppBar(
        title: const Text(
          'Data Warga',
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
          Consumer<WargaProvider>(
            builder: (context, provider, _) {
              if (provider.filters.isNotEmpty) {
                return Badge(
                  backgroundColor: Colors.red,
                  label: Text(provider.filters.length.toString()),
                  offset: const Offset(-8, 8),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt_rounded),
                    onPressed: _showFilterDialog,
                    tooltip: 'Filter',
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: _showFilterDialog,
                tooltip: 'Filter',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Aktif (Ditampilkan seperti Chips di atas list)
          Consumer<WargaProvider>(
            builder: (context, provider, _) {
              if (provider.filters.isEmpty) return const SizedBox.shrink();
              return _buildActiveFilters(provider);
            },
          ),

          // Search Bar (Optional: Jika ingin persis seperti desain lama yg tidak ada search bar, hapus bagian ini.
          // Tapi search bar sangat berguna, jadi saya sarankan tetap ada dengan style minimalis).
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama warga...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          context.read<WargaProvider>().loadWarga();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
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

          // Content List
          Expanded(
            child: Consumer<WargaProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const common_widgets.LoadingWidget(
                    message: 'Memuat data warga...',
                  );
                }

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

                final wargaList = provider.filteredWargaList;
                if (wargaList.isEmpty) {
                  return common_widgets.EmptyStateWidget(
                    message: provider.filters.isNotEmpty
                        ? 'Tidak ada warga yang sesuai filter'
                        : 'Belum ada data warga',
                    icon: Icons.search_off,
                    actionLabel: 'Tambah Warga',
                    onActionPressed: () =>
                        Navigator.pushNamed(context, '/warga/add'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.loadWarga();
                    await provider.loadKeluarga();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: wargaList.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                        onEdit: isAdmin || isSekretaris
                            ? () => Navigator.pushNamed(
                                context,
                                '/warga/edit',
                                arguments: warga,
                              )
                            : null,
                        onDelete: isAdmin || isSekretaris
                            ? () => _confirmDelete(
                                context,
                                warga.nik,
                                warga.namaLengkap,
                              )
                            : null,
                        // onEdit: () {
                        //   Navigator.pushNamed(
                        //     context,
                        //     '/warga/edit',
                        //     arguments: warga,
                        //   );
                        // },
                        // onDelete: () {
                        //   _confirmDelete(context, warga.nik, warga.namaLengkap);
                        // },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin || isSekretaris
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/warga/add');
              },
              backgroundColor: Colors.blue, // Sesuaikan warna FAB
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
            )
          : null,
    );
  }

  // Widget helper untuk menampilkan filter aktif (mirip dengan filter_chips.dart design)
  Widget _buildActiveFilters(WargaProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list, size: 14, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                "Filter Aktif",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => provider.clearFilters(),
                child: Text(
                  "Hapus Semua",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: provider.filters.entries.map((entry) {
              if (entry.value.isEmpty) return const SizedBox.shrink();
              return Chip(
                label: Text(
                  '${entry.key}: ${entry.value}',
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: Colors.blue.withOpacity(0.1),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.blue,
                ),
                onDeleted: () {
                  final newFilters = Map<String, String>.from(provider.filters);
                  newFilters.remove(entry.key);
                  provider.applyFilters(newFilters);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
