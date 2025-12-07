import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
import '../providers/keuangan_provider.dart';

class KategoriIuranPage extends StatefulWidget {
  const KategoriIuranPage({super.key});

  @override
  State<KategoriIuranPage> createState() => _KategoriIuranPageState();
}

class _KategoriIuranPageState extends State<KategoriIuranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<KeuanganProvider>(context, listen: false).initData(),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Jenis Iuran"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Iuran (Cth: Sampah)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nominal Default",
                  border: OutlineInputBorder(),
                  prefixText: "Rp ",
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final nominal =
                    double.tryParse(
                      _nominalController.text.replaceAll('.', ''),
                    ) ??
                    0;
                final success = await Provider.of<KeuanganProvider>(
                  context,
                  listen: false,
                ).tambahKategori(_namaController.text, nominal);

                if (success && mounted) {
                  Navigator.pop(ctx);
                  _namaController.clear();
                  _nominalController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Kategori berhasil ditambahkan"),
                    ),
                  );
                }
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(userEmail: "admin@jawara.com"),
      appBar: AppBar(title: const Text("Kategori Iuran")),
      body: Consumer<KeuanganProvider>(
        builder: (context, provider, _) {
          // Filter hanya kategori yang memiliki nominal default > 0 (asumsi ini iuran)
          final listIuran = provider.listKategori
              .where((e) => e.nominalDefault > 0)
              .toList();

          return listIuran.isEmpty
              ? const Center(child: Text("Belum ada kategori iuran."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: listIuran.length,
                  itemBuilder: (context, index) {
                    final item = listIuran[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.monetization_on,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        title: Text(
                          item.namaKategori,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Tarif Standar: ${currencyFormatter.format(item.nominalDefault)}",
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF6A5AE0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
