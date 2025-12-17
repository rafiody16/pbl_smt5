import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Ganti import ini sesuai struktur project Anda
import '../../../sidebar/sidebar.dart';
import '../../../providers/produk_provider.dart';
import '../../../services/visual_search_service.dart';
// import '../../../services/toast_service.dart';

class MarketplaceListPage extends StatefulWidget {
  const MarketplaceListPage({Key? key}) : super(key: key);

  @override
  State<MarketplaceListPage> createState() => _MarketplaceListPageState();
}

class _MarketplaceListPageState extends State<MarketplaceListPage> {
  final TextEditingController _searchController = TextEditingController();
  File? _searchImage; // Menyimpan gambar untuk filter visual
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load data produk awal
      context.read<ProdukProvider>().loadProduk();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

      final keyword = await VisualSearchService.predictBatik(imageFile);

      if (!mounted) return;

      if (keyword != null) {
        setState(() {
          _searchController.text = keyword;
        });

        context.read<ProdukProvider>().searchProduk(keyword);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Motif terdeteksi: $keyword")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal mendeteksi batik")));
      }
    } catch (e) {
      debugPrint("Visual search error: $e");
    }
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
            title: const Text('Cari dengan Kamera'),
            onTap: () {
              Navigator.pop(ctx);
              _pickImageAndSearch(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.green),
            title: const Text('Cari dengan Gambar Galeri'),
            onTap: () {
              Navigator.pop(ctx);
              _pickImageAndSearch(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void _clearVisualSearch() {
    setState(() {
      _searchImage = null;
    });
    context.read<ProdukProvider>().loadProduk(); // Reset ke semua produk
  }

  // --- Logic Cart & Buy ---
  void _addToCart(dynamic produk) {
    // Implementasi ke provider cart
    // context.read<CartProvider>().addToCart(produk);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${produk['nama_produk']} masuk keranjang"),
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
        actions: [
          // Icon Keranjang Belanja
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  // Navigator.pushNamed(context, '/cart');
                },
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
                    "2", // Ganti dengan total item dinamis
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const Sidebar(),
      body: Column(
        children: [
          // --- Header: Search Bar & Visual Search Indicator ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari produk...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.blue,
                            ),
                            tooltip: "Cari dengan Gambar",
                            onPressed: _showVisualSearchOptions,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (val) {
                          // context.read<ProdukProvider>().searchProduk(val);
                        },
                      ),
                    ),
                  ],
                ),

                // Jika sedang filter gambar, tampilkan previewnya
                if (_searchImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue),
                            image: DecorationImage(
                              image: FileImage(_searchImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Mencari berdasarkan gambar...",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: _clearVisualSearch,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --- Kategori (Optional) ---
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildCategoryChip("Semua", true),
                _buildCategoryChip("Makanan", false),
                _buildCategoryChip("Minuman", false),
                _buildCategoryChip("Kerajinan", false),
                _buildCategoryChip("Jasa", false),
              ],
            ),
          ),

          // --- Grid Produk ---
          Expanded(
            child: Consumer<ProdukProvider>(
              builder: (context, provider, _) {
                final produkList = [
                  {
                    'id': 1,
                    'nama_produk': 'Batik Kawung',
                    'harga': 15000,
                    'stok': 20,
                    'gambar_url': 'https://via.placeholder.com/150',
                    'seller': 'Bu Ani',
                  },
                  {
                    'id': 2,
                    'nama_produk': 'Batik Krawitan',
                    'harga': 25000,
                    'stok': 10,
                    'gambar_url': 'https://via.placeholder.com/150',
                    'seller': 'Pak Budi',
                  },
                  {
                    'id': 3,
                    'nama_produk': 'Batik Nitik',
                    'harga': 75000,
                    'stok': 99,
                    'gambar_url': 'https://via.placeholder.com/150',
                    'seller': 'Teknik Jaya',
                  },
                ];

                if (produkList.isEmpty) {
                  return const Center(child: Text("Belum ada produk"));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 Kolom
                    childAspectRatio: 0.70, // Rasio kartu (tinggi > lebar)
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: produkList.length,
                  itemBuilder: (context, index) {
                    final produk = produkList[index];
                    return _buildProductCard(produk);
                  },
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
        tooltip: "Jual Produk",
      ),
    );
  }

  // --- Widgets ---

  Widget _buildCategoryChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isActive,
        onSelected: (bool value) {},
        backgroundColor: Colors.white,
        selectedColor: Colors.blue.shade100,
        labelStyle: TextStyle(
          color: isActive ? Colors.blue.shade800 : Colors.black87,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isActive ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildProductCard(dynamic produk) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Gambar Produk
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(produk['gambar_url']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. Info Produk
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk['nama_produk'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormat.format(produk['harga']),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.orange, // Warna khas harga e-commerce
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.store, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        produk['seller'],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Action Buttons (Beli & Keranjang)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                InkWell(
                  onTap: () => _addToCart(produk),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Tombol Beli (Besar)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/checkout', arguments: produk);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("Beli"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
