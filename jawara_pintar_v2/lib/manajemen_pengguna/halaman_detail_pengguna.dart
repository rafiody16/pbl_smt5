// lib/halaman/manajemen_pengguna/halaman_detail_pengguna.dart

import 'package:flutter/material.dart';
import '../../model/pengguna.dart';
import '../../sidebar/sidebar.dart';
import 'komponen/card_detail_pengguna.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

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
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              label: const Text('Kembali'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Detail Pengguna',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            UserDetailCard(user: user), // Memanggil komponen kartu detail
          ],
        ),
      ),
    );
  }
}