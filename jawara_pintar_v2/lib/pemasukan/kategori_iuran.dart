import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan path

class KategoriIuranData {
  final int no;
  final String namaIuran;
  final String jenisIuran;
  final double nominal;

  KategoriIuranData({
    required this.no,
    required this.namaIuran,
    required this.jenisIuran,
    required this.nominal,
  });
}

class KategoriIuran extends StatefulWidget {
  const KategoriIuran({super.key});

  @override
  State<KategoriIuran> createState() => _KategoriIuranState();
}

class _KategoriIuranState extends State<KategoriIuran> {
  final List<KategoriIuranData> _kategoriIuranList = [
    KategoriIuranData(
      no: 1,
      namaIuran: 'Iuran Kebersihan',
      jenisIuran: 'Bulanan',
      nominal: 25000,
    ),
    KategoriIuranData(
      no: 2,
      namaIuran: 'Iuran Keamanan',
      jenisIuran: 'Bulanan',
      nominal: 20000,
    ),
    KategoriIuranData(
      no: 3,
      namaIuran: 'Iuran Sosial',
      jenisIuran: 'Khusus',
      nominal: 50000,
    ),
  ];

  // --- State untuk filter ---
  final TextEditingController _namaFilterController = TextEditingController();
  String? _selectedJenis;
  List<KategoriIuranData> _filteredList = [];

  final List<String> _jenisOptions = ['Bulanan', 'Khusus'];

  // --- Formatting ---
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  int _currentPage = 1;
  static const int _itemsPerPage = 5; // Bisa disesuaikan

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void dispose() {
    _namaFilterController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredList = _kategoriIuranList.where((iuran) {
        // Filter Nama
        if (_namaFilterController.text.isNotEmpty &&
            !iuran.namaIuran.toLowerCase().contains(
              _namaFilterController.text.toLowerCase(),
            )) {
          return false;
        }
        // Filter Jenis
        if (_selectedJenis != null && iuran.jenisIuran != _selectedJenis) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Kategori Iuran"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(


//         padding: const EdgeInsets.all(24.0),
//         child: Container(
//           padding: const EdgeInsets.all(24.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                   },
//                   icon: const Icon(Icons.add, color: Colors.white),
//                   label: const Text(
//                     "Tambah Iuran",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF6A5AE0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 14,
//                       horizontal: 18,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minWidth: constraints.maxWidth,
//                       ),
//                       child: DataTable(
//                         columnSpacing: 20,
//                         headingRowColor: WidgetStateProperty.all(
//                           Colors.grey.shade100,
//                         ),
//                         columns: const [
//                           DataColumn(
//                             label: Text(
//                               'NO',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'NAMA IURAN',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'JENIS IURAN',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'NOMINAL',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'AKSI',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                         rows: _kategoriIuranList.map((iuran) {
//                           final currencyFormatter = NumberFormat.currency(
//                             locale: 'id_ID',
//                             symbol: 'Rp',
//                             decimalDigits: 0,
//                           );

//                           return DataRow(
//                             cells: [
//                               DataCell(Text(iuran.no.toString())),
//                               DataCell(Text(iuran.namaIuran)),
//                               DataCell(Text(iuran.jenisIuran)),
//                               DataCell(
//                                 Text(currencyFormatter.format(iuran.nominal)),
//                               ),
//                               DataCell(
//                                 IconButton(
//                                   icon: const Icon(Icons.more_horiz),
//                                   onPressed: () {
//                                     // Logika untuk aksi (edit, hapus, dll)
//                                   },
//                                 ),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 24),

//               // Paginasi
//               _buildPagination(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPagination() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.chevron_left),
//           onPressed: _currentPage > 1
//               ? () => setState(() => _currentPage--)
//               : null,
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: const Color(0xFF6A5AE0),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             _currentPage.toString(),
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.chevron_right),
//           onPressed: () {
//           },
//         ),
//       ],
//     );
//   }
// }


padding: const EdgeInsets.all(16.0),
        child: Container(
          // PERBAIKAN 2: Padding container dikurangi
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tombol Filter
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showFilterDialog(context),
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      label: const Text("Filter"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5AE0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Aksi tambah iuran
                      _showAddEditDialog(context);
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Tambah",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Daftar Card
              _filteredList.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "Data tidak ditemukan.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    )
                  : Column(
                      children: _getPaginatedData()
                          .map((iuran) => _buildIuranCard(iuran))
                          .toList(),
                    ),

              const SizedBox(height: 24),
              // Pagination
              _buildPagination(),
            ],
          ),
        ),
      ),
    );
  }

  List<KategoriIuranData> _getPaginatedData() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(
      startIndex,
      _filteredList.length,
    );
    return _filteredList.sublist(startIndex, endIndex);
  }

  Widget _buildIuranCard(KategoriIuranData iuran) {
    Color borderColor = iuran.jenisIuran == 'Bulanan'
        ? const Color(0xFF63C2DE)
        : const Color(0xFFF76C6C);
    Color statusColor = iuran.jenisIuran == 'Bulanan'
        ? Colors.blue
        : Colors.purple;
    String statusText = iuran.jenisIuran;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: borderColor, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Nama & Jenis
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        iuran.jenisIuran.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        iuran.namaIuran,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right: Status & Aksi
                Row(
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
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        // Aksi: edit/hapus
                        _showActionDialog(context, iuran);
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
            Row(
              children: [
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
                        currencyFormatter.format(iuran.nominal),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
    final totalPages = (_filteredList.length / _itemsPerPage).ceil();
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
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
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
                        "Filter Iuran",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nama Filter
                  const Text(
                    "Nama Iuran",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _namaFilterController,
                    decoration: InputDecoration(
                      hintText: "Cari nama...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Jenis Filter
                  const Text(
                    "Jenis Iuran",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedJenis,
                    hint: const Text("-- Pilih Jenis --"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: _jenisOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        _selectedJenis = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setDialogState(() {
                            _namaFilterController.clear();
                            _selectedJenis = null;
                          });
                          _applyFilters();
                        },
                        child: const Text("Reset"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(context);
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

  void _showActionDialog(BuildContext context, KategoriIuranData iuran) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Aksi"),
        content: Text("Apa yang ingin dilakukan dengan '${iuran.namaIuran}'?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showAddEditDialog(context, data: iuran);
            },
            child: const Text("Edit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Simulasi hapus
              setState(() {
                _kategoriIuranList.remove(iuran);
                _applyFilters();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Iuran ${iuran.namaIuran} dihapus")),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {KategoriIuranData? data}) {
    final namaController = TextEditingController(text: data?.namaIuran);
    final jenisController = TextEditingController(text: data?.jenisIuran);
    final nominalController = TextEditingController(
      text: data?.nominal.toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(data == null ? "Tambah Iuran" : "Edit Iuran"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Iuran"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: jenisController.text.isEmpty
                    ? null
                    : jenisController.text,
                items: _jenisOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => jenisController.text = v ?? '',
                decoration: const InputDecoration(labelText: "Jenis Iuran"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nominal"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaController.text.isEmpty ||
                  jenisController.text.isEmpty ||
                  nominalController.text.isEmpty)
                return;

              final nominal = double.tryParse(nominalController.text) ?? 0;

              final newData = KategoriIuranData(
                no: data?.no ?? _kategoriIuranList.length + 1,
                namaIuran: namaController.text,
                jenisIuran: jenisController.text,
                nominal: nominal,
              );

              if (data == null) {
                _kategoriIuranList.add(newData);
              } else {
                final index = _kategoriIuranList.indexOf(data);
                _kategoriIuranList[index] = newData;
              }

              _applyFilters();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Iuran ${newData.namaIuran} ${data == null ? 'ditambahkan' : 'diperbarui'}",
                  ),
                ),
              );
            },
            child: Text(data == null ? "Simpan" : "Perbarui"),
          ),
        ],
      ),
    );
  }
}
