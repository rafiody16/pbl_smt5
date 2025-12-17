import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Import Model, Provider, dan Halaman Form
import '../../models/produk.dart';
import '../../providers/produk_provider.dart';
import '../../services/toast_service.dart';
import 'produk_form_page.dart';

class ProdukListPage extends StatefulWidget {
  const ProdukListPage({Key? key}) : super(key: key);

  @override
  State<ProdukListPage> createState() => _ProdukListPageState();
}

class _ProdukListPageState extends State<ProdukListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Provider.of<ProdukProvider>(context, listen: false).loadProduk();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper untuk format mata uang IDR
  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  // Navigasi ke Form (Tambah/Edit)
  void _navigateToForm({Produk? produk}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukFormPage(
          // Kuncinya disini: Konversi Model Produk ke Map karena Form meminta Map
          existingProduk: produk?.toMap(),
        ),
      ),
    );
    // Refresh data setelah kembali dari form
    if (mounted) {
      _loadData();
    }
  }

  // Dialog Konfirmasi Hapus
  void _confirmDelete(Produk produk) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: Text("Yakin ingin menghapus '${produk.namaProduk}'?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Tutup dialog

              // Proses Hapus via Provider
              final provider = context.read<ProdukProvider>();
              bool success = await provider.deleteProduk(produk.id!);

              if (mounted) {
                if (success) {
                  ToastService.showSuccess(context, "Produk berhasil dihapus");
                } else {
                  ToastService.showError(
                    context,
                    provider.errorMessage ?? "Gagal menghapus",
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF), // Background senada dengan Form
      appBar: AppBar(
        title: const Text(
          "Manajemen Produk",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(), // Mode Tambah (null)
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Tambah Produk",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Cari produk Anda...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onChanged: (value) {
                  // Panggil fungsi search di provider
                  context.read<ProdukProvider>().searchProduk(value);
                },
              ),
            ),
          ),

          // --- LIST DATA ---
          Expanded(
            child: Consumer<ProdukProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.produkList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Belum ada produk",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      80,
                    ), // Bottom padding for FAB
                    itemCount: provider.produkList.length,
                    itemBuilder: (context, index) {
                      final produk = provider.produkList[index];
                      return _buildProductCard(produk);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Produk produk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToForm(produk: produk), // Mode Edit
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Gambar Produk
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[100],
                    child:
                        (produk.gambarUrl != null &&
                            produk.gambarUrl!.isNotEmpty)
                        ? Image.network(
                            produk.gambarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                  ),
                ),

                const SizedBox(width: 12),

                // 2. Informasi Produk
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produk.namaProduk,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatCurrency(
                          produk.harga.toDouble(),
                        ), // Tambahkan .toDouble()
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildBadge(
                            icon: Icons.inventory_2,
                            text: "${produk.stok} unit",
                            color: Colors.blue[50]!,
                            textColor: Colors.blue[700]!,
                          ),
                          const SizedBox(width: 8),
                          _buildBadge(
                            icon: Icons.category,
                            text: produk.kategori,
                            color: Colors.orange[50]!,
                            textColor: Colors.orange[800]!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Tombol Delete (Kanan Atas)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(produk),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
