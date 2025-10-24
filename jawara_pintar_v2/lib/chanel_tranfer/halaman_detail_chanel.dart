import 'package:flutter/material.dart';
import '../../model/chanel_transfer.dart';
import '../../sidebar/sidebar.dart';
import 'komponen/detail_chanel_card.dart';

class HalamanDetailChanel extends StatelessWidget {
  final ChanelTransfer chanel;

  const HalamanDetailChanel({super.key, required this.chanel});

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
              'Detail Transfer Channel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: DetailChanelCard(chanel: chanel),
            ),
          ],
        ),
      ),
    );
  }
}