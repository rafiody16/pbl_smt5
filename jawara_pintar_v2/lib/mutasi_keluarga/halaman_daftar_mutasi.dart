import 'package:flutter/material.dart';
import '../../model/mutasi.dart';
import '../../sidebar/sidebar.dart'; 
import 'komponen/tabel_daftar_mutasi.dart';
import 'halaman_detail_mutasi.dart'; 

import '../../data/data_mutasi.dart'; 

class MutasiDaftarScreen extends StatelessWidget {
  const MutasiDaftarScreen({super.key});


  void _goToDetail(BuildContext context, Mutasi mutasi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MutasiDetailScreen(mutasi: mutasi),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jawara Pintar.'),
      ),
      drawer: const Sidebar(userEmail: "admin@jawara.com"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(height: 10),
            const Text(
              'Daftar Mutasi Keluarga',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            MutasiListTable(
              // --- PERUBAHAN 3: Gunakan data dari MutasiData.mutasiList ---
              mutasiList: DataMutasi.mutasiList,
              onDetailTap: (mutasi) {
                _goToDetail(context, mutasi);
              },
            ),
          ],
        ),
      ),
    );
  }
}