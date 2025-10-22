import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

class TagihIuran extends StatefulWidget {
  const TagihIuran({super.key});

  @override
  State<TagihIuran> createState() => _TagihIuranState();
}

class _TagihIuranState extends State<TagihIuran> {
  String? selectedIuran;

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(title: const Text('Tagih Iuran ke Semua Keluarga Aktif')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tagih iuran ke Semua Keluarga Aktif',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('Jenis Iuran'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedIuran,
                  hint: const Text('-- Pilih Iuran --'),
                  items: const [
                    DropdownMenuItem(value: 'mingguan', child: Text('Mingguan')),
                    DropdownMenuItem(value: 'bulanan', child: Text('Bulanan')),
                    DropdownMenuItem(value: 'tahunan', child: Text('Tahunan')),
                  ],
                  onChanged: (val) => setState(() => selectedIuran = val),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text('Tagih Iuran'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => setState(() => selectedIuran = null),
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
}
