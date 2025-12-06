import 'package:flutter/material.dart';
import '../../sidebar/sidebar.dart';
import '../components/form/form_rumah.dart';
import '../../../services/toast_service.dart';
import '../../dashboard/keuangan.dart';

class RumahTambahPage extends StatefulWidget {
  const RumahTambahPage({super.key});

  @override
  State<RumahTambahPage> createState() => _RumahTambahPageState();
}

class _RumahTambahPageState extends State<RumahTambahPage> {
  final _formKey = GlobalKey<FormState>();

  String _alamat = '';
  String _status = 'Tersedia';

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // TODO: simpan data baru ke database atau state management
      print('Data rumah baru:');
      print('Alamat: $_alamat');
      print('Status: $_status');

      ToastService.showSuccess(context, "Data rumah berhasil ditambahkan");

      Future.delayed(const Duration(milliseconds: 1500), () {
        _navigateToDashboard();
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const DashboardPage()
      ),
      (route) => false,
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _alamat = '';
      _status = 'Tersedia';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form telah direset'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Map<String, dynamic> get _formData {
    return {
      'alamat': _alamat,
      'status': _status,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          "Tambah Rumah",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _navigateToDashboard,
        ),
      ),
      drawer: const Sidebar(userEmail: 'admin@jawara.com'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 48,
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(Icons.add_home_work, color: Colors.blue, size: 28),
//                         ),
//                         const SizedBox(width: 16),
//                         const Text(
//                           "Tambah Rumah Baru",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     const Divider(height: 1, color: Colors.grey),
//                     const SizedBox(height: 24),

//                     FormRumah(
//                       initialData: _formData,
//                       formKey: _formKey,
//                       onAlamatChanged: (value) => _alamat = value,
//                       onStatusChanged: (value) => setState(() => _status = value),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 OutlinedButton(
//                   onPressed: _resetForm,
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.grey[700],
//                     side: BorderSide(color: Colors.grey[300]!),
//                     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text("Reset"),
//                 ),
//                 const SizedBox(width: 12),
//                 ElevatedButton(
//                   onPressed: _saveData,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_home_work,
                              color: Colors.blue, size: 28),
                        ),
                        const SizedBox(width: 16),
                        // Gunakan Expanded agar teks tidak overflow ke kanan
                        const Expanded( 
                          child: Text(
                            "Tambah Rumah Baru",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            // Opsional: Batasi baris atau biarkan wrap
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 24),

                    FormRumah(
                      initialData: _formData,
                      formKey: _formKey,
                      onAlamatChanged: (value) => _alamat = value,
                      onStatusChanged: (value) =>
                          setState(() => _status = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            
            // --- PERBAIKAN 2: Tombol Aksi ---
            // Menggunakan Wrap lebih aman daripada Row untuk tombol
            // Jika layar sempit, tombol Reset akan naik di atas Submit
            Container(
              alignment: Alignment.centerRight, // Rata kanan
              child: Wrap(
                spacing: 12, // Jarak horizontal antar tombol
                runSpacing: 12, // Jarak vertikal jika tombol turun ke bawah
                alignment: WrapAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _resetForm,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
            // Tambahan padding bawah agar tombol tidak mepet layar bawah 
            // saat di-scroll mentok
            const SizedBox(height: 20), 
         ],
        ),
      ),
    );
  }
}