import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Import sesuai struktur project Anda
import '../../../sidebar/sidebar.dart';
import '../../../providers/produk_provider.dart';
import '../../../services/visual_search_service.dart';
import '../../../models/produk.dart'; // Pastikan model Produk diimport

class MarketplaceListPage extends StatefulWidget {
  const MarketplaceListPage({Key? key}) : super(key: key);

  @override
  State<MarketplaceListPage> createState() => _MarketplaceListPageState();
}

class _MarketplaceListPageState extends State<MarketplaceListPage> {
  final TextEditingController _searchController = TextEditingController();
  File? _searchImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Memuat data asli dari provider saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdukProvider>().loadProduk();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Logic Pencarian Visual ---
  Future<void> _pickImageAndSearch(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100,
        maxWidth: 1024,
      );

      if (pickedFile == null) return;

      final imageFile = File(pickedFile.path);

      setState(() {
        _searchImage = imageFile;
        _searchController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Menganalisis motif batik...")),
      );

      // Memanggil service visual search
      final keyword = await VisualSearchService.predictBatik(imageFile);

      if (!mounted) return;

      if (keyword != null) {
        setState(() {
          _searchController.text = keyword;
        });
        // Memfilter produk di provider berdasarkan hasil AI
        context.read<ProdukProvider>().searchProduk(keyword);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Motif terdeteksi: $keyword")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mendeteksi motif batik")),
        );
      }
    } catch (e) {
      debugPrint("Visual search error: $e");
    }
  }

  void _clearVisualSearch() {
    setState(() {
      _searchImage = null;
      _searchController.clear();
    });
    context.read<ProdukProvider>().loadProduk();
  }

  void _addToCart(Produk produk) {
    // Implementasi keranjang bisa ditambahkan di sini
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${produk.namaProduk} ditambahkan ke keranjang"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          'Marketplace',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [_buildCartBadge(), const SizedBox(width: 8)],
      ),
      drawer: const Sidebar(),
      body: Column(
        children: [
          // --- Search Bar & Visual Search Preview ---
          _buildSearchBar(),

          // --- Filter Kategori ---
          _buildCategoryFilter(),

          // --- Grid Produk (Data Real dari Provider) ---
          Expanded(
            child: Consumer<ProdukProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.produkList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text("Produk tidak ditemukan"),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadProduk(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/produk/add'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- Widget Components ---

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (val) =>
                context.read<ProdukProvider>().searchProduk(val),
            decoration: InputDecoration(
              hintText: 'Cari kain, baju, motif...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.blue),
                onPressed: _showVisualSearchOptions,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (_searchImage != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _searchImage!,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Mencari motif serupa...",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: _clearVisualSearch,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Produk produk) {
    final priceFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                color: Colors.grey[100],
                child:
                    (produk.gambarUrl != null && produk.gambarUrl!.isNotEmpty)
                    ? Image.network(
                        produk.gambarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          // Info Produk
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.namaProduk,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  priceFormat.format(produk.harga),
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Stok: ${produk.stok}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _addToCart(produk),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text("Beli", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildCategoryChip("Semua", true),
          _buildCategoryChip("Kain Batik", false),
          _buildCategoryChip("Pakaian", false),
          _buildCategoryChip("Aksesoris", false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.white : Colors.black87,
          ),
        ),
        selected: isActive,
        onSelected: (_) {},
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildCartBadge() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {},
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              "0",
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
          ),
        ),
      ],
    );
  }

  void _showVisualSearchOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.blue),
            title: const Text('Ambil Foto Motif'),
            onTap: () {
              Navigator.pop(ctx);
              _pickImageAndSearch(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.green),
            title: const Text('Pilih dari Galeri'),
            onTap: () {
              Navigator.pop(ctx);
              _pickImageAndSearch(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
