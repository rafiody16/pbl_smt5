import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

class Tagihan extends StatefulWidget {
  const Tagihan({super.key});

  @override
  State<Tagihan> createState() => _TagihanState();
}

class _TagihanState extends State<Tagihan> {
  // Data dummy
  final List<Map<String, dynamic>> _allTagihan = [
    {
      'no': 1,
      'keluarga': 'Keluarga Habibie Ed Dien',
      'status': 'Aktif',
      'iuran': 'Mingguan',
      'kode': 'IR175458A501',
      'nominal': 10000,
      'periode': DateTime(2025, 10, 8),
      'statusTagihan': 'Belum Dibayar',
    },
    {
      'no': 2,
      'keluarga': 'Keluarga Mara Nunez',
      'status': 'Aktif',
      'iuran': 'Agustusan',
      'kode': 'IR224406BC02',
      'nominal': 15000,
      'periode': DateTime(2025, 10, 10),
      'statusTagihan': 'Belum Dibayar',
    },
    {
      'no': 3,
      'keluarga': 'Keluarga Sitorus',
      'status': 'Aktif',
      'iuran': 'Bulanan',
      'kode': 'IR334407AB03',
      'nominal': 25000,
      'periode': DateTime(2025, 9, 1),
      'statusTagihan': 'Dibayar',
    },
  ];

  // === Filter & Search ===
  final TextEditingController _searchController = TextEditingController();
  String? _selectedIuran; // null = semua jenis
  List<Map<String, dynamic>> _filteredTagihan = [];
  int _currentPage = 1;
  static const int _itemsPerPage = 5;

  // === Formatter ===
  // Pakai locale aman untuk Web, simbol diset "Rp "
  final NumberFormat currency = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Tanpa locale 'id_ID' agar tidak perlu inisialisasi locale di Web
  final DateFormat dateFormatter = DateFormat('d MMM yyyy');

  // === Dropdown Options ===
  final List<String> _iuranOptions = [
    'Mingguan',
    'Bulanan',
    'Agustusan',
    'Khusus',
    'Tahunan',
  ];

  @override
  void initState() {
    super.initState();
    _filteredTagihan = List.from(_allTagihan);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      final search = _searchController.text.toLowerCase();

      _filteredTagihan = _allTagihan.where((tagihan) {
        // Filter nama keluarga
        if (search.isNotEmpty &&
            !tagihan['keluarga'].toString().toLowerCase().contains(search)) {
          return false;
        }

        // Filter jenis iuran (jika dipilih)
        if (_selectedIuran != null &&
            _selectedIuran!.isNotEmpty &&
            tagihan['iuran'] != _selectedIuran) {
          return false;
        }

        return true;
      }).toList();

      _currentPage = 1; // reset halaman saat filter berubah
    });
  }

  List<Map<String, dynamic>> _getPaginatedData() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(
      startIndex,
      _filteredTagihan.length,
    );
    return _filteredTagihan.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text('Daftar Tagihan'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
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
                // Baris atas: search + filter + PDF
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Cari nama keluarga...",
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => _applyFilters(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _showFilterDialog(context),
                      icon: const Icon(Icons.filter_alt, size: 18),
                      label: const Text("Filter"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
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
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Fitur cetak PDF sedang dikembangkan",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf, size: 18),
                      label: const Text("PDF"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Daftar card
                _filteredTagihan.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            "Data tagihan tidak ditemukan.",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          children: _getPaginatedData()
                              .map(_buildTagihanCard)
                              .toList(),
                        ),
                      ),

                // Pagination
                if (_filteredTagihan.length > _itemsPerPage) ...[
                  const SizedBox(height: 16),
                  _buildPagination(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagihanCard(Map<String, dynamic> tagihan) {
    // Warna berdasarkan status tagihan
    final bool isPaid = tagihan['statusTagihan'] == 'Dibayar';

    Color borderColor = isPaid
        ? const Color(0xFF28A745)
        : const Color(0xFFF76C6C);
    Color statusColor = isPaid ? Colors.green : Colors.orange;
    String statusText = tagihan['statusTagihan'];

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
            // Baris atas: nama keluarga + status + aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiri: jenis iuran + nama keluarga
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tagihan['iuran'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tagihan['keluarga'],
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Kanan: status tagihan + tombol aksi
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: statusColor, size: 10),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        // Aksi tambahan: detail, konfirmasi, dsb.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Aksi untuk ${tagihan['keluarga']}"),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),

            // Baris bawah: kode, nominal, periode
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
                        tagihan['kode'],
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
                        currency.format(tagihan['nominal']),
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
                        "PERIODE",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormatter.format(tagihan['periode'] as DateTime),
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

  Widget _buildPagination() {
    final totalPages = (_filteredTagihan.length / _itemsPerPage).ceil();
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
            _currentPage.toString(),
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

  void _showFilterDialog(BuildContext context) {
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
                  // Header dialog
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

                  // Jenis Iuran
                  const Text(
                    "Jenis Iuran",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedIuran,
                    hint: const Text("-- Semua Jenis --"),
                    items: _iuranOptions
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() => _selectedIuran = value);
                    },
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

                  // Tombol aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setDialogState(() {
                            _selectedIuran = null;
                          });
                          _applyFilters();
                        },
                        child: const Text("Reset"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A5AE0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Terapkan",
                          style: TextStyle(color: Colors.white),
                        ),
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
