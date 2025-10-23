import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../sidebar/sidebar.dart';
import '../../../services/toast_service.dart';
import '../../dashboard/keuangan.dart';
import '../../../data/kegiatan_data.dart';

class KegiatanTambahPage extends StatefulWidget {
  const KegiatanTambahPage({super.key});

  @override
  State<KegiatanTambahPage> createState() => _KegiatanTambahPageState();
}

class _KegiatanTambahPageState extends State<KegiatanTambahPage> {
  final _formKey = GlobalKey<FormState>();

  String _nama = '';
  String? _kategori;
  String? _tanggal;
  String _lokasi = '';
  String _deskripsi = '';
  String _penanggungJawab = '';

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print('Data kegiatan baru:');
      print('Nama: $_nama');
      print('Kategori: $_kategori');
      print('Tanggal: $_tanggal');
      print('Lokasi: $_lokasi');
      print('Deskripsi: $_deskripsi');
      print('Penanggung Jawab: $_penanggungJawab');

      ToastService.showSuccess(context, "Kegiatan berhasil ditambahkan");

      Future.delayed(const Duration(milliseconds: 1500), () {
        _navigateToDashboard();
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardPage()),
      (route) => false,
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _nama = '';
      _kategori = null;
      _tanggal = null;
      _lokasi = '';
      _deskripsi = '';
      _penanggungJawab = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form telah direset'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id', 'ID'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tanggal = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  Map<String, dynamic> get _formData {
    return {
      'nama': _nama,
      'kategori': _kategori,
      'tanggal': _tanggal,
      'lokasi': _lokasi,
      'deskripsi': _deskripsi,
      'penanggung_jawab': _penanggungJawab,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          "Tambah Kegiatan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
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
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.event_available,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            "Tambah Kegiatan",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow:
                                TextOverflow.ellipsis, // Tambahan opsional
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 24),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nama Kegiatan',
                              hintText: 'Contoh: Donor Darah Bersama PMI',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Nama wajib diisi' : null,
                            onSaved: (value) => _nama = value!,
                          ),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Kategori Kegiatan',
                              hintText: '-- Pilih Kategori --',
                            ),
                            value: _kategori,
                            items: KegiatanData.kategoriKegiatan.map((
                              kategori,
                            ) {
                              return DropdownMenuItem(
                                value: kategori,
                                child: Text(kategori),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _kategori = value),
                            validator: (value) =>
                                value == null ? 'Kategori wajib dipilih' : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Tanggal Pelaksanaan',
                              hintText: 'Pilih tanggal kegiatan',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today_outlined),
                                onPressed: _selectDate,
                              ),
                            ),
                            controller: TextEditingController(
                              text: _tanggal ?? '',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Tanggal wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Lokasi',
                              hintText: 'Contoh: Balai Desa Jatirasa',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Lokasi wajib diisi' : null,
                            onSaved: (value) => _lokasi = value!,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Penanggung Jawab',
                              hintText: 'Contoh: Pak Dedi / Ibu Lina',
                            ),
                            validator: (value) => value!.isEmpty
                                ? 'Penanggung jawab wajib diisi'
                                : null,
                            onSaved: (value) => _penanggungJawab = value!,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Deskripsi',
                              hintText:
                                  'Tuliskan detail kegiatan (tujuan, peserta, waktu, dsb.)',
                            ),
                            maxLines: 4,
                            onSaved: (value) => _deskripsi = value!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Reset"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Tambah"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
