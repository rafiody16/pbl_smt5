import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
import '../providers/keuangan_provider.dart';
import '../models/keuangan_models.dart';
import 'tagih_iuran.dart'; // Untuk tombol "Buat Tagihan"

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  // === Filter & Search ===
  final TextEditingController _searchController = TextEditingController();
  String? _selectedKategoriNama; // Filter berdasarkan nama kategori

  // Pagination State
  int _currentPage = 1;
  static const int _itemsPerPage = 5;

  // === Formatter ===
  final NumberFormat currency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final DateFormat dateFormatter = DateFormat('d MMM yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
    // Load data saat halaman dibuka
    Future.microtask(
      () => Provider.of<KeuanganProvider>(context, listen: false).initData(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "admin@jawara.com";

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text('Daftar Tagihan'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          // Tombol Refresh Manual
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<KeuanganProvider>(
              context,
              listen: false,
            ).initData(),
          ),
        ],
      ),
      body: Consumer<KeuanganProvider>(
        builder: (context, provider, child) {
          // 1. Ambil Data Mentah (Pemasukan)
          // Asumsi: Tagihan adalah semua data di tabel pemasukan
          // (Bisa difilter status 'Belum Lunas' saja jika mau, tapi di sini kita tampilkan semua history)
          List<PemasukanModel> filteredList = provider.listPemasukan;

          // 2. Terapkan Search (Client Side)
          if (_searchController.text.isNotEmpty) {
            final searchLower = _searchController.text.toLowerCase();
            filteredList = filteredList.where((item) {
              return item.judul.toLowerCase().contains(searchLower);
            }).toList();
          }

          // 3. Terapkan Filter Kategori (Client Side)
          if (_selectedKategoriNama != null) {
            filteredList = filteredList.where((item) {
              final namaKat = provider.getNamaKategori(item.kategoriId);
              return namaKat == _selectedKategoriNama;
            }).toList();
          }

          // 4. Pagination Logic
          final int totalItems = filteredList.length;
          final int totalPages = (totalItems / _itemsPerPage).ceil();

          // Reset page jika out of range karena filter
          if (_currentPage > totalPages && totalPages > 0) {
            _currentPage = 1;
          }

          final int startIndex = (_currentPage - 1) * _itemsPerPage;
          final int endIndex = (startIndex + _itemsPerPage).clamp(
            0,
            totalItems,
          );

          // Data yang akan dirender di halaman ini
          final paginatedData = filteredList.sublist(startIndex, endIndex);

          // === UI UTAMA ===
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // --- HEADER: SEARCH & FILTER ---
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Cari nama / judul...",
                              prefixIcon: const Icon(Icons.search, size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            onChanged: (val) =>
                                setState(() {}), // Rebuild saat ketik
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => _showFilterDialog(context, provider),
                          icon: const Icon(Icons.filter_alt, size: 18),
                          label: const Text("Filter"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5AE0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Tombol Tambah Tagihan Baru
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => const TagihIuranPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Buat"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- CONTENT: LIST TAGIHAN ---
                    provider.isLoading
                        ? const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : paginatedData.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text(
                                "Data tagihan tidak ditemukan.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: paginatedData.length,
                              itemBuilder: (context, index) {
                                final item = paginatedData[index];
                                final namaKategori = provider.getNamaKategori(
                                  item.kategoriId,
                                );
                                return _buildTagihanCard(item, namaKategori);
                              },
                            ),
                          ),

                    // --- FOOTER: PAGINATION ---
                    if (totalItems > _itemsPerPage) ...[
                      const SizedBox(height: 16),
                      _buildPagination(totalPages),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTagihanCard(PemasukanModel tagihan, String namaKategori) {
    // Logic Status
    // Normalisasi string (biar aman kalau database beda case)
    final statusRaw = tagihan.statusBayar?.toLowerCase() ?? 'belum lunas';
    final bool isPaid = statusRaw == 'lunas' || statusRaw == 'dibayar';

    Color borderColor = isPaid
        ? const Color(0xFF28A745)
        : const Color(0xFFF76C6C);
    Color statusColor = isPaid ? Colors.green : Colors.redAccent;
    String statusText = isPaid ? "LUNAS" : "BELUM LUNAS";

    // Generate Fake Code biar keren: TRX-000001
    String kodeTransaksi = "TRX-${tagihan.id.toString().padLeft(6, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 5)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas: Kategori + Judul + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaKategori.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tagihan.judul,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: statusColor, size: 8),
                          const SizedBox(width: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tombol Aksi (Misal: Bayar / Edit)
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        // TODO: Tambahkan fitur update status jadi lunas di sini
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Fitur update status segera hadir"),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),

            // Baris bawah: Kode, Nominal, Periode
            Row(
              children: [
                // Kode
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "KODE",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kodeTransaksi,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                // Nominal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NOMINAL",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currency.format(tagihan.nominal),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                // Periode
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TANGGAL",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormatter.format(tagihan.tanggalTransaksi),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
          color: _currentPage > 1 ? null : Colors.grey,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF6A5AE0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "$_currentPage / $totalPages",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages
              ? () => setState(() => _currentPage++)
              : null,
          color: _currentPage < totalPages ? null : Colors.grey,
        ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context, KeuanganProvider provider) {
    // Ambil list unik nama kategori untuk dropdown
    final List<String> kategoriOptions = provider.listKategori
        .map((e) => e.namaKategori)
        .toSet() // Hapus duplikat
        .toList();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter Tagihan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Jenis Iuran",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedKategoriNama,
                    hint: const Text("-- Semua Jenis --"),
                    items: kategoriOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => _selectedKategoriNama = value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setDialogState(() => _selectedKategoriNama = null);
                          setState(
                            () => _selectedKategoriNama = null,
                          ); // Update parent state juga
                          Navigator.pop(ctx);
                        },
                        child: const Text("Reset"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Trigget parent rebuild dengan setState di parent widget
                          setState(() {});
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A5AE0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Terapkan"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
