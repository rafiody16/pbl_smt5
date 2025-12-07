// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

// // --- Halaman Utama Cetak Laporan ---
// class Laporan extends StatefulWidget {
//   const Laporan({super.key});

//   @override
//   State<Laporan> createState() => _LaporanState();
// }

// class _LaporanState extends State<Laporan> {
//   // Controller untuk mengelola input tanggal
//   final TextEditingController _tanggalMulaiController = TextEditingController();
//   final TextEditingController _tanggalAkhirController = TextEditingController();

//   // Variabel untuk menyimpan pilihan dropdown
//   String? _jenisLaporanTerpilih = 'Semua';
//   final List<String> _opsiJenisLaporan = ['Semua', 'Pemasukan', 'Pengeluaran'];

//   // Variabel untuk validasi
//   bool _sudahDicobaDownload = false;

//   // Fungsi untuk menampilkan date picker
//   Future<void> _pilihTanggal(
//     BuildContext context,
//     TextEditingController controller,
//   ) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         controller.text = DateFormat('dd-MM-yyyy').format(picked);
//       });
//     }
//   }

//   // Fungsi untuk mereset semua input
//   void _resetForm() {
//     setState(() {
//       _tanggalMulaiController.clear();
//       _tanggalAkhirController.clear();
//       _jenisLaporanTerpilih = 'Semua';
//       _sudahDicobaDownload = false;
//     });
//   }

//   // Fungsi untuk validasi dan download
//   void _downloadPdf() {
//     setState(() {
//       _sudahDicobaDownload = true;
//     });

//     // Cek apakah semua field sudah diisi
//     if (_tanggalMulaiController.text.isNotEmpty &&
//         _tanggalAkhirController.text.isNotEmpty) {
//       // Jika valid, tampilkan dialog (logika download PDF sebenarnya akan di sini)
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Logika download PDF dijalankan...'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _tanggalMulaiController.dispose();
//     _tanggalAkhirController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const String currentUserEmail = "user@example.com"; // Placeholder

//     return Scaffold(
//       drawer: const Sidebar(userEmail: currentUserEmail),
//       backgroundColor: const Color(0xfff0f4f7),
//       appBar: AppBar(
//         title: const Text("Cetak Laporan Keuangan"),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         elevation: 1,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 800),
//             padding: const EdgeInsets.all(32.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Input Tanggal
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: _buildDateField(
//                         'Tanggal Mulai',
//                         _tanggalMulaiController,
//                       ),
//                     ),
//                     const SizedBox(width: 24),
//                     Expanded(
//                       child: _buildDateField(
//                         'Tanggal Akhir',
//                         _tanggalAkhirController,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),

//                 // Dropdown Jenis Laporan
//                 _buildDropdownField('Jenis Laporan'),
//                 const SizedBox(height: 32),

//                 // Tombol Aksi
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: _downloadPdf,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF6A5AE0),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 20,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text('Download PDF'),
//                     ),
//                     const SizedBox(width: 16),
//                     OutlinedButton(
//                       onPressed: _resetForm,
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.grey.shade700,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 20,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         side: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       child: const Text('Reset'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget helper untuk input tanggal
//   Widget _buildDateField(String label, TextEditingController controller) {
//     final bool showError = _sudahDicobaDownload && controller.text.isEmpty;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           readOnly: true,
//           decoration: InputDecoration(
//             hintText: '--/--/----',
//             suffixIcon: const Icon(Icons.calendar_today),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             errorText: showError ? '$label wajib diisi.' : null,
//             errorStyle: const TextStyle(color: Colors.red),
//           ),
//           onTap: () => _pilihTanggal(context, controller),
//         ),
//       ],
//     );
//   }

//   // Widget helper untuk dropdown
//   Widget _buildDropdownField(String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: _jenisLaporanTerpilih,
//           items: _opsiJenisLaporan.map((String value) {
//             return DropdownMenuItem<String>(value: value, child: Text(value));
//           }).toList(),
//           onChanged: (newValue) {
//             setState(() {
//               _jenisLaporanTerpilih = newValue;
//             });
//           },
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

// --- Halaman Utama Cetak Laporan ---
class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  // Controller untuk mengelola input tanggal
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalAkhirController = TextEditingController();

  // Variabel untuk menyimpan pilihan dropdown
  String? _jenisLaporanTerpilih = 'Semua';
  final List<String> _opsiJenisLaporan = ['Semua', 'Pemasukan', 'Pengeluaran'];

  // Variabel untuk validasi
  bool _sudahDicobaDownload = false;

  // Fungsi untuk menampilkan date picker
  Future<void> _pilihTanggal(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  // Fungsi untuk mereset semua input
  void _resetForm() {
    setState(() {
      _tanggalMulaiController.clear();
      _tanggalAkhirController.clear();
      _jenisLaporanTerpilih = 'Semua';
      _sudahDicobaDownload = false;
    });
  }

  // Fungsi untuk validasi dan download
  void _downloadPdf() {
    setState(() {
      _sudahDicobaDownload = true;
    });

    // Cek apakah semua field sudah diisi
    if (_tanggalMulaiController.text.isNotEmpty &&
        _tanggalAkhirController.text.isNotEmpty) {
      // Jika valid, tampilkan dialog (logika download PDF sebenarnya akan di sini)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logika download PDF dijalankan...'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tanggalMulaiController.dispose();
    _tanggalAkhirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com"; // Placeholder

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Cetak Laporan Keuangan"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(32.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Input Tanggal
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildDateField(
                        'Tanggal Mulai',
                        _tanggalMulaiController,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDateField(
                        'Tanggal Akhir',
                        _tanggalAkhirController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Dropdown Jenis Laporan
                _buildDropdownField('Jenis Laporan'),
                const SizedBox(height: 32),

                // Tombol Aksi (FIX: Menggunakan Wrap untuk menghindari overflow)
                Wrap(
                  spacing: 16.0, // Jarak horizontal antar tombol
                  runSpacing: 16.0, // Jarak vertikal jika tombol turun ke baris baru
                  children: [
                    ElevatedButton(
                      onPressed: _downloadPdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5AE0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Download PDF'),
                    ),
                    OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk input tanggal
  Widget _buildDateField(String label, TextEditingController controller) {
    final bool showError = _sudahDicobaDownload && controller.text.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: '--/--/----',
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            errorText: showError ? '$label wajib diisi.' : null,
            errorStyle: const TextStyle(color: Colors.red),
          ),
          onTap: () => _pilihTanggal(context, controller),
        ),
      ],
    );
  }

  // Widget helper untuk dropdown
  Widget _buildDropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _jenisLaporanTerpilih,
          items: _opsiJenisLaporan.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _jenisLaporanTerpilih = newValue;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}