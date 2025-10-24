import 'package:flutter/material.dart';
import '../../sidebar/sidebar.dart'; // Sesuaikan path sidebar Anda
import '../chanel_tranfer/komponen/form_tambah_chanel.dart';

class ChanelTambahScreen extends StatelessWidget {
  const ChanelTambahScreen({super.key});

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
              'Buat Transfer Channel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Membungkus form agar responsif (mengisi lebar)
            const SizedBox(
              width: double.infinity,
              child: FormTambahChanel(),
            ),
          ],
        ),
      ),
    );
  }
}