import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart'; // Sesuaikan jika perlu

class TagihIuran extends StatefulWidget {
  const TagihIuran({super.key});

  @override
  State<TagihIuran> createState() => _TagihIuranState();
}

class _TagihIuranState extends State<TagihIuran> {
  final _formKey = GlobalKey<FormState>();
  String? selectedIuran;
  DateTime? tanggalTagih;

  // Simulasi data keluarga aktif
  int getTotalKeluargaAktif() => 42; // Bisa dipanggil dari API/database nanti

  @override
  Widget build(BuildContext context) {
    const String currentUserEmail = "user@example.com";

    void _pickTanggal() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          tanggalTagih = picked;
        });
      }
    }

    void _submitTagihan() {
      if (_formKey.currentState!.validate()) {
        // Konfirmasi sebelum menagih
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Konfirmasi Penagihan"),
            content: Text(
              "Anda akan menagihkan iuran ${selectedIuran!.toUpperCase()} ke ${getTotalKeluargaAktif()} "
              "keluarga aktif pada tanggal ${tanggalTagih!.day}/${tanggalTagih!.month}/${tanggalTagih!.year}. "
              "Apakah Anda yakin?",
              style: const TextStyle(height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Tutup dialog
                  Navigator.pop(context); // Kembali ke halaman sebelumnya (opsional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Tagihan iuran $selectedIuran berhasil dikirim ke ${getTotalKeluargaAktif()} keluarga!",
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Ya, Tagih"),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      drawer: const Sidebar(userEmail: currentUserEmail),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text('Tagih Iuran ke Semua Keluarga Aktif'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Tagih Iuran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tagihkan iuran ke semua keluarga aktif sekaligus.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // Informasi keluarga aktif
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBBDEF), width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.family_restroom, size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          '${getTotalKeluargaAktif()} Keluarga Aktif',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === Jenis Iuran ===
                  const Text(
                    'Jenis Iuran',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedIuran,
                    hint: const Text('-- Pilih Jenis Iuran --'),
                    items: const [
                      DropdownMenuItem(value: 'mingguan', child: Text('Iuran Mingguan')),
                      DropdownMenuItem(value: 'bulanan', child: Text('Iuran Bulanan')),
                      DropdownMenuItem(value: 'tahunan', child: Text('Iuran Tahunan')),
                    ],
                    onChanged: (String? value) {
                      setState(() => selectedIuran = value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih jenis iuran';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // === Tanggal Tagihan ===
                  const Text(
                    'Tanggal Penagihan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    onTap: _pickTanggal,
                    decoration: InputDecoration(
                      hintText: 'Pilih tanggal penagihan',
                      labelText: tanggalTagih == null
                          ? null
                          : '${tanggalTagih!.day}/${tanggalTagih!.month}/${tanggalTagih!.year}',
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) {
                      if (tanggalTagih == null) {
                        return 'Tanggal penagihan harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5AE0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _submitTagihan,
                          child: const Text('Tagih Iuran'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedIuran = null;
                              tanggalTagih = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}