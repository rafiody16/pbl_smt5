import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan path

// Model data untuk daftar pemasukan lain
class PemasukanLainDaftarData {
  final int no;
  final String nama;
  final String jenisPengeluaran;
  final DateTime tanggal;
  final double nominal;

  PemasukanLainDaftarData({
    required this.no,
    required this.nama,
    required this.jenisPengeluaran,
    required this.tanggal,
    required this.nominal,
  });
}

class PemasukanLainDaftar extends StatefulWidget {
  const PemasukanLainDaftar({super.key});

  @override
  State<PemasukanLainDaftar> createState() => _PemasukanLainDaftarState();
}

class _PemasukanLainDaftarState extends State<PemasukanLainDaftar> {
  // Data contoh statis
  final List<PemasukanLainDaftarData> _pemasukanLainDaftarList = [
    PemasukanLainDaftarData(
      no: 1,
      nama: 'Daftar Kebersihan',
      jenisPengeluaran: 'Bulanan',
      tanggal: DateTime(2025, 10, 1),
      nominal: 25000,
    ),
    PemasukanLainDaftarData(
      no: 2,
      nama: 'Daftar Keamanan',
      jenisPengeluaran: 'Bulanan',
      tanggal: DateTime(2025, 9, 15),
      nominal: 20000,
    ),
    PemasukanLainDaftarData(
      no: 3,
      nama: 'Daftar Sosial',
      jenisPengeluaran: 'Khusus',
      tanggal: DateTime(2025, 8, 20),
      nominal: 50000,
    ),
  ];

  // === Fitur Filter ===
  final TextEditingController _namaFilterController = TextEditingController();
  String? _selectedJenis;
  List<PemasukanLainDaftarData> _filteredList = [];

  final List<String> _jenisOptions = ['Bulanan', 'Khusus'];

  // === Pagination ===
  int _currentPage = 1;
  static const int _itemsPerPage = 5;

  // === Formatting ===
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  final dateFormatter = DateFormat('dd/MM/yyyy', 'id_ID');

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
      _filteredList = _pemasukanLainDaftarList.where((item) {
        // Filter Nama
        if (_namaFilterController.text.isNotEmpty &&
            !item.nama.toLowerCase().contains(
              _namaFilterController.text.toLowerCase(),
            )) {
          return false;
        }
        // Filter Jenis
        if (_selectedJenis != null && item.jenisPengeluaran != _selectedJenis) {
          return false;
        }
        return true;
      }).toList();
      // Reset ke hal. 1 saat filter berubah
      _currentPage = 1;
    });
  }

  List<PemasukanLainDaftarData> _getPaginatedData() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredList.sublist(
      startIndex,
      endIndex > _filteredList.length ? _filteredList.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Pemasukan Lain - Daftar"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
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
              // Tombol Filter dan Tambah
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
                    onPressed: () => _showAddEditDialog(context),
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
                          .map((item) => _buildDaftarCard(item))
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

  Widget _buildDaftarCard(PemasukanLainDaftarData item) {
    bool isBulanan = item.jenisPengeluaran == 'Bulanan';
    Color borderColor = isBulanan
        ? const Color(0xFF63C2DE)
        : const Color(0xFFF76C6C);
    Color statusColor = isBulanan ? Colors.blue : Colors.purple;

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
            // Baris Atas: Nama & Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kiri: Jenis & Nama
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.jenisPengeluaran.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.nama,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Kanan: Status & Aksi
                Row(
                  children: [
                    Icon(Icons.circle, color: statusColor, size: 10),
                    const SizedBox(width: 6),
                    Text(
                      isBulanan ? 'Bulanan' : 'Khusus',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () => _showActionDialog(context, item),
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

            // Baris Bawah: Tanggal & Nominal
            Row(
              children: [
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
                        dateFormatter.format(item.tanggal),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
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
                        currencyFormatter.format(item.nominal),
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
                        "Filter Daftar",
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

                  // Nama
                  const Text(
                    "Nama",
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

                  // Jenis
                  const Text(
                    "Jenis Pengeluaran",
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
                    items: _jenisOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setDialogState(() {
                        _selectedJenis = v;
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

  void _showActionDialog(BuildContext context, PemasukanLainDaftarData item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Aksi"),
        content: Text("Apa yang ingin dilakukan dengan '${item.nama}'?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showAddEditDialog(context, data: item);
            },
            child: const Text("Edit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _pemasukanLainDaftarList.remove(item);
                _applyFilters();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Data ${item.nama} dihapus")),
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

  void _showAddEditDialog(
    BuildContext context, {
    PemasukanLainDaftarData? data,
  }) {
    final namaController = TextEditingController(text: data?.nama);
    final jenisController = TextEditingController(text: data?.jenisPengeluaran);
    final nominalController = TextEditingController(
      text: data?.nominal.toString(),
    );
    final tanggalController = TextEditingController(
      text: data != null ? dateFormatter.format(data.tanggal) : '',
    );

    DateTime? selectedDate = data?.tanggal;

    void _pickDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        selectedDate = picked;
        tanggalController.text = dateFormatter.format(picked);
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(data == null ? "Tambah Daftar" : "Edit Daftar"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama"),
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
                decoration: const InputDecoration(
                  labelText: "Jenis Pengeluaran",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tanggalController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  labelText: "Tanggal",
                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                ),
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
                  nominalController.text.isEmpty ||
                  selectedDate == null)
                return;

              final nominal = double.tryParse(nominalController.text) ?? 0;

              final newData = PemasukanLainDaftarData(
                no: data?.no ?? _pemasukanLainDaftarList.length + 1,
                nama: namaController.text,
                jenisPengeluaran: jenisController.text,
                tanggal: selectedDate!,
                nominal: nominal,
              );

              if (data == null) {
                _pemasukanLainDaftarList.add(newData);
              } else {
                final index = _pemasukanLainDaftarList.indexOf(data);
                _pemasukanLainDaftarList[index] = newData;
              }

              _applyFilters();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Data ${newData.nama} ${data == null ? 'ditambahkan' : 'diperbarui'}",
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
