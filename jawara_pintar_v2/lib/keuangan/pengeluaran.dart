import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan package 'intl' sudah ada di pubspec.yaml
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan path ini

// Model data untuk setiap baris pengeluaran
class PengeluaranData {
  final int no;
  final String nama;
  final String jenisPengeluaran;
  final DateTime tanggal;
  final double nominal;

  PengeluaranData({
    required this.no,
    required this.nama,
    required this.jenisPengeluaran,
    required this.tanggal,
    required this.nominal,
  });
}

// --- Halaman Utama Laporan Pengeluaran ---
class Pengeluaran extends StatefulWidget {
  const Pengeluaran({super.key});

  @override
  State<Pengeluaran> createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  // Data statis sebagai contoh
  final List<PengeluaranData> _allPengeluaranList = [
    PengeluaranData(
      no: 1,
      nama: 'Kerja Bakti',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 10, 19, 20, 26),
      nominal: 5000000,
    ),
    PengeluaranData(
      no: 2,
      nama: 'Kerja Bakti',
      jenisPengeluaran: 'Kegiatan Warga',
      tanggal: DateTime(2025, 10, 19, 20, 26),
      nominal: 10000000,
    ),
    PengeluaranData(
      no: 3,
      nama: 'Arka',
      jenisPengeluaran: 'Operasional RT/RW',
      tanggal: DateTime(2025, 10, 17, 2, 31),
      nominal: 6000000,
    ),
    PengeluaranData(
      no: 4,
      nama: 'adsad',
      jenisPengeluaran: 'Pemeliharaan Fasilitas',
      tanggal: DateTime(2025, 10, 10, 1, 8),
      nominal: 2112000,
    ),
  ];

  // --- BARU: List untuk data yang sudah difilter ---
  List<PengeluaranData> _filteredPengeluaranList = [];

  int _currentPage = 1;

  // --- BARU: State untuk menyimpan nilai filter ---
  final TextEditingController _namaFilterController = TextEditingController();
  String? _selectedKategori; // Akan menyimpan 'Jenis Pengeluaran' yang dipilih
  DateTime? _selectedDariTanggal;
  DateTime? _selectedSampaiTanggal;
  final TextEditingController _dariTanggalController = TextEditingController();
  final TextEditingController _sampaiTanggalController =
      TextEditingController();

  // Opsi untuk dropdown
  List<String> _kategoriOptions = [];
  // --- Akhir Bagian Baru ---

  // --- BARU: initState untuk inisialisasi list ---
  @override
  void initState() {
    super.initState();
    // Ambil jenis unik dari data list
    final uniqueJenis = _allPengeluaranList
        .map((p) => p.jenisPengeluaran)
        .toSet();
    _kategoriOptions = uniqueJenis.toList();
    // Awalnya, tampilkan semua data
    _filteredPengeluaranList = List.from(_allPengeluaranList);
  }
  // --- Akhir Bagian Baru ---

  // --- BARU: Dispose controllers ---
  @override
  void dispose() {
    _namaFilterController.dispose();
    _dariTanggalController.dispose();
    _sampaiTanggalController.dispose();
    super.dispose();
  }
  // --- Akhir Bagian Baru ---

  // --- BARU: Logika untuk menerapkan filter ---
  void _applyFilter() {
    setState(() {
      _filteredPengeluaranList = _allPengeluaranList.where((pengeluaran) {
        // Filter Nama
        final bool namaMatch =
            _namaFilterController.text.isEmpty ||
            pengeluaran.nama.toLowerCase().contains(
              _namaFilterController.text.toLowerCase(),
            );

        // Filter Kategori (Jenis Pengeluaran)
        final bool kategoriMatch =
            _selectedKategori == null ||
            pengeluaran.jenisPengeluaran == _selectedKategori;

        // Filter Dari Tanggal
        final bool dariTanggalMatch =
            _selectedDariTanggal == null ||
            pengeluaran.tanggal.isAfter(
              _selectedDariTanggal!.subtract(const Duration(seconds: 1)),
            ); // Buat inklusif

        // Filter Sampai Tanggal
        final bool sampaiTanggalMatch =
            _selectedSampaiTanggal == null ||
            pengeluaran.tanggal.isBefore(
              _selectedSampaiTanggal!.add(const Duration(days: 1)),
            ); // Buat inklusif

        return namaMatch &&
            kategoriMatch &&
            dariTanggalMatch &&
            sampaiTanggalMatch;
      }).toList();
    });
    Navigator.of(context).pop(); // Tutup dialog setelah filter diterapkan
  }
  // --- Akhir Bagian Baru ---

  // --- BARU: Logika untuk reset filter ---
  void _resetFilter(void Function(void Function()) setDialogState) {
    setDialogState(() {
      _namaFilterController.clear();
      _selectedKategori = null;
      _selectedDariTanggal = null;
      _selectedSampaiTanggal = null;
      _dariTanggalController.clear();
      _sampaiTanggalController.clear();
    });
    // Terapkan reset ke list utama
    setState(() {
      _filteredPengeluaranList = List.from(_allPengeluaranList);
    });
  }
  // --- Akhir Bagian Baru ---

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com"; // Placeholder email

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Laporan Pengeluaran"),
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
              // Tombol Filter
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // --- MODIFIKASI: Panggil dialog filter ---
                    _showFilterDialog(context);
                  },
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text(""), // Label dikosongkan
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tabel Data
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: 20,
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade100,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'NO',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NAMA',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'JENIS PENGELUARAN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'TANGGAL',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NOMINAL',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'AKSI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        // --- MODIFIKASI: Gunakan list yang sudah difilter ---
                        rows: _filteredPengeluaranList.map((pengeluaran) {
                          final currencyFormatter = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 2,
                          );
                          final dateFormatter = DateFormat(
                            'd MMM yyyy HH:mm',
                            'id_ID',
                          );

                          return DataRow(
                            cells: [
                              DataCell(Text(pengeluaran.no.toString())),
                              DataCell(Text(pengeluaran.nama)),
                              DataCell(Text(pengeluaran.jenisPengeluaran)),
                              DataCell(
                                Text(dateFormatter.format(pengeluaran.tanggal)),
                              ),
                              DataCell(
                                Text(
                                  currencyFormatter.format(pengeluaran.nominal),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () {
                                    // Logika untuk aksi
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Paginasi
              _buildPagination(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk kontrol paginasi
  Widget _buildPagination() {
    // TODO: Logika paginasi perlu disesuaikan dengan data yang difilter
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
          color: Colors.grey,
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
          onPressed: null, // Dinonaktifkan untuk contoh ini
          color: Colors.grey,
        ),
      ],
    );
  }

  // --- BARU: Method untuk menampilkan dialog filter ---
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Gunakan StatefulBuilder agar state di dalam dialog (seperti dropdown)
        // bisa di-update tanpa menutup dialog.
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              child: _buildFilterDialogContent(context, setDialogState),
            );
          },
        );
      },
    );
  }

  // --- BARU: Method untuk membangun konten dialog ---
  Widget _buildFilterDialogContent(
    BuildContext context,
    void Function(void Function()) setDialogState,
  ) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      constraints: const BoxConstraints(maxWidth: 400), // Batasi lebar dialog
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Dialog ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Pengeluaran", // <-- MODIFIKASI
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Form Fields ---
          // Nama
          const Text("Nama", style: TextStyle(fontWeight: FontWeight.w600)),
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

          // Kategori (Jenis Pengeluaran)
          const Text(
            "Jenis Pengeluaran",
            style: TextStyle(fontWeight: FontWeight.w600),
          ), // <-- MODIFIKASI
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: const Text("-- Pilih Jenis Pengeluaran --"), // <-- MODIFIKASI
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            items: _kategoriOptions.map((String value) {
              // Menggunakan list dinamis
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (newValue) {
              // Update state di dalam dialog
              setDialogState(() {
                _selectedKategori = newValue;
              });
            },
          ),
          const SizedBox(height: 16),

          // Dari Tanggal
          const Text(
            "Dari Tanggal",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDatePickerField(
            context: context,
            controller: _dariTanggalController,
            onDateSelected: (date) {
              setDialogState(() {
                _selectedDariTanggal = date;
              });
            },
            onClear: () {
              setDialogState(() {
                _selectedDariTanggal = null;
                _dariTanggalController.clear();
              });
            },
          ),
          const SizedBox(height: 16),

          // Sampai Tanggal
          const Text(
            "Sampai Tanggal",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDatePickerField(
            context: context,
            controller: _sampaiTanggalController,
            onDateSelected: (date) {
              setDialogState(() {
                _selectedSampaiTanggal = date;
              });
            },
            onClear: () {
              setDialogState(() {
                _selectedSampaiTanggal = null;
                _sampaiTanggalController.clear();
              });
            },
          ),
          const SizedBox(height: 24),

          // --- Tombol Aksi Dialog ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Panggil fungsi reset
                  _resetFilter(setDialogState);
                },
                child: const Text("Reset Filter"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyFilter, // Panggil fungsi terapkan filter
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A5AE0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: const Text("Terapkan"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- BARU: Widget helper untuk field tanggal ---
  Widget _buildDatePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required Function(DateTime) onDateSelected,
    required VoidCallback onClear,
  }) {
    return TextField(
      controller: controller,
      readOnly: true, // Buat field tidak bisa diketik manual
      decoration: InputDecoration(
        hintText: "-- / -- / ----",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        // Sesuai gambar, ada 2 ikon di kanan
        suffixIcon: Row(
          mainAxisSize:
              MainAxisSize.min, // Penting agar Row tidak memakan tempat
          children: [
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: onClear, // Panggil fungsi clear
              splashRadius: 20,
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, size: 20),
              onPressed: () => _pickDate(context, controller, onDateSelected),
              splashRadius: 20,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      onTap: () => _pickDate(
        context,
        controller,
        onDateSelected,
      ), // Panggil juga saat field diklik
    );
  }

  // --- BARU: Logika untuk memunculkan date picker ---
  Future<void> _pickDate(
    BuildContext context,
    TextEditingController controller,
    Function(DateTime) onDateSelected,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Tanggal awal
      lastDate: DateTime(2101), // Tanggal akhir
    );
    if (pickedDate != null) {
      // Format tanggal sesuai keinginan
      String formattedDate = DateFormat('dd / MM / yyyy').format(pickedDate);
      controller.text = formattedDate; // Update text di field
      onDateSelected(pickedDate); // Simpan tanggal di state
    }
  }
}
