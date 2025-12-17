import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/produk.dart';
import '../../providers/produk_provider.dart';
import '../../services/toast_service.dart';
import '../../../sidebar/sidebar.dart'; // Import Sidebar Anda
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    await Provider.of<ProdukProvider>(context, listen: false).loadProduk();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToForm({Produk? produk}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukFormPage(existingProduk: produk?.toMap()),
      ),
    );
    if (mounted) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      // MENAMBAHKAN SIDEBAR
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text(
          "Manajemen Produk",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  // Bagian Header Pencarian (Mencegah Overfitting di build method)
  Widget _buildSearchHeader() {
    return Padding(
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
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onChanged: (value) {
            context.read<ProdukProvider>().searchProduk(value);
          },
        ),
      ),
    );
  }

  // Bagian List Produk dengan Consumer
  Widget _buildProductList() {
    return Consumer<ProdukProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.produkList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            itemCount: provider.produkList.length,
            itemBuilder: (context, index) => _ProductListItem(
              produk: provider.produkList[index],
              onEdit: () => _navigateToForm(produk: provider.produkList[index]),
              onDelete: () => _confirmDelete(provider.produkList[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Belum ada produk",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Produk produk) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: Text("Yakin ingin menghapus '${produk.namaProduk}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await context.read<ProdukProvider>().deleteProduk(
                produk.id!,
              );
              if (mounted && success)
                ToastService.showSuccess(context, "Terhapus");
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Widget Komponen Terpisah untuk Item List (Mencegah Overfitting Kode)
class _ProductListItem extends StatelessWidget {
  final Produk produk;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductListItem({
    required this.produk,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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
      child: ListTile(
        onTap: onEdit,
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey[100],
            child: (produk.gambarUrl?.isNotEmpty ?? false)
                ? Image.network(produk.gambarUrl!, fit: BoxFit.cover)
                : const Icon(Icons.image_not_supported),
          ),
        ),
        title: Text(
          produk.namaProduk,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatCurrency.format(produk.harga),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _Badge(text: "${produk.stok} unit", color: Colors.blue),
                const SizedBox(width: 8),
                _Badge(text: produk.kategori, color: Colors.orange),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
