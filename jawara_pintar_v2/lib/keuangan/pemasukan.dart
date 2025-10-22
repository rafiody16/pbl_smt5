import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml untuk format tanggal & mata uang
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan path ini

// Model data untuk setiap baris pemasukan
class PemasukanData {
  final int no;
  final String nama;
  final String jenisPemasukan;
  final DateTime tanggal;
  final double nominal;

  PemasukanData({
    required this.no,
    required this.nama,
    required this.jenisPemasukan,
    required this.tanggal,
    required this.nominal,
  });
}

// --- Halaman Utama Laporan Pemasukan ---
class Pemasukan extends StatefulWidget {
  const Pemasukan({super.key});

  @override
  State<Pemasukan> createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  // Data statis sebagai contoh, sesuai gambar
  final List<PemasukanData> _pemasukanList = [
    PemasukanData(
      no: 1,
      nama: 'Atabik',
      jenisPemasukan: 'Dana Bantuan Pemerintah',
      tanggal: DateTime(2025, 10, 15, 14, 23),
      nominal: 11000000,
    ),
    PemasukanData(
      no: 2,
      nama: 'Mutawakil',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 10, 13, 0, 55),
      nominal: 49999997,
    ),
    PemasukanData(
      no: 3,
      nama: 'Handoko',
      jenisPemasukan: 'Pendapatan Lainnya',
      tanggal: DateTime(2025, 8, 12, 13, 26),
      nominal: 10000000,
    ),
  ];

  int _currentPage = 1;

  // --- BARU: State untuk menyimpan nilai filter ---
  final TextEditingController _namaFilterController = TextEditingController();
  String? _selectedKategori;
  DateTime? _selectedDariTanggal;
  DateTime? _selectedSampaiTanggal;
  final TextEditingController _dariTanggalController = TextEditingController();
  final TextEditingController _sampaiTanggalController =
      TextEditingController();

  // Opsi untuk dropdown kategori
  final List<String> _kategoriOptions = [
    'Dana Bantuan Pemerintah',
    'Pendapatan Lainnya',
  ];
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

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com"; // Placeholder email

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Laporan Pemasukan"),
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
                  label: const Text(
                    "",
                  ), // Label dikosongkan agar hanya ikon terlihat rapi
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
                        headingRowColor: WidgetStateProperty.all(
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
                              'JENIS PEMASUKAN',
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
                        rows: _pemasukanList
                            .map((pemasukan) {
                              // Filter logic (Contoh sederhana)
                              // Anda bisa membuat logic ini lebih kompleks
                              if (_namaFilterController.text.isNotEmpty &&
                                  !pemasukan.nama.toLowerCase().contains(
                                    _namaFilterController.text.toLowerCase(),
                                  )) {
                                return null; // Sembunyikan jika tidak cocok
                              }
                              if (_selectedKategori != null &&
                                  pemasukan.jenisPemasukan !=
                                      _selectedKategori) {
                                return null; // Sembunyikan jika tidak cocok
                              }
                              // Tambahkan filter tanggal di sini jika perlu

                              // Formatter untuk mata uang Rupiah
                              final currencyFormatter = NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp',
                                decimalDigits: 2,
                              );
                              // Formatter untuk tanggal
                              final dateFormatter = DateFormat(
                                'd MMM yyyy HH:mm',
                                'id_ID',
                              );

                              return DataRow(
                                cells: [
                                  DataCell(Text(pemasukan.no.toString())),
                                  DataCell(Text(pemasukan.nama)),
                                  DataCell(Text(pemasukan.jenisPemasukan)),
                                  DataCell(
                                    Text(
                                      dateFormatter.format(pemasukan.tanggal),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      currencyFormatter.format(
                                        pemasukan.nominal,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.more_horiz),
                                      onPressed: () {
                                        // Logika untuk aksi (edit, delete, dll)
                                      },
                                    ),
                                  ),
                                ],
                              );
                            })
                            .whereType<DataRow>()
                            .toList(), // Hanya ambil baris yang tidak null
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
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
          onPressed: () {
            // Logika untuk halaman selanjutnya, sesuaikan jika data dinamis
            // setState(() => _currentPage++);
          },
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
                "Filter Pemasukan",
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

          // Kategori
          const Text("Kategori", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: const Text("-- Pilih Kategori --"),
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
              return DropdownMenuItem<String>(value: value, child: Text(value));
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
                  // Reset semua filter
                  setDialogState(() {
                    _namaFilterController.clear();
                    _selectedKategori = null;
                    _selectedDariTanggal = null;
                    _selectedSampaiTanggal = null;
                    _dariTanggalController.clear();
                    _sampaiTanggalController.clear();
                  });
                },
                child: const Text("Reset Filter"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Terapkan filter dan tutup dialog
                  // Panggil setState dari halaman utama untuk memfilter tabel
                  setState(() {});
                  Navigator.of(context).pop();
                },
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
