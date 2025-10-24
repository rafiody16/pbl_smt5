import 'package:flutter/material.dart';
import '../../data/chanel_data.dart';
import '../../model/chanel_transfer.dart';
import '../../sidebar/sidebar.dart';
import 'halaman_detail_chanel.dart';
import 'halaman_edit_chanel.dart';
import 'halaman_tambah_chanel.dart';
import 'komponen/list_item_chanel.dart';

class HalamanDaftarChanel extends StatefulWidget {
  const HalamanDaftarChanel({super.key});

  @override
  State<HalamanDaftarChanel> createState() => _HalamanDaftarChanelState();
}

class _HalamanDaftarChanelState extends State<HalamanDaftarChanel> {
  // Kita gunakan List dari data dummy
  late List<ChanelTransfer> _chanels;

  @override
  void initState() {
    super.initState();
    _chanels = ChanelData.chanels;
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context, ChanelTransfer chanel) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
              'Apakah kamu yakin ingin menghapus item ini? Aksi ini tidak dapat dibatalkan.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Hapus'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // Logika Hapus
                setState(() {
                  _chanels.removeWhere((c) => c.id == chanel.id);
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Item berhasil dihapus (Simulasi)')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Navigasi
  void _goToDetail(ChanelTransfer chanel) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HalamanDetailChanel(chanel: chanel)),
    );
  }

  void _goToEdit(ChanelTransfer chanel) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HalamanEditChanel(chanel: chanel)),
    ).then((_) => setState(() {})); // Refresh list
  }

  void _goToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChanelTambahScreen()),
    ).then((_) => setState(() {})); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jawara Pintar.'),
      ),
      drawer: const Sidebar(userEmail: "admin@jawara.com"),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _chanels.length,
        itemBuilder: (context, index) {
          final chanel = _chanels[index];
          return ListItemChanel(
            chanel: chanel,
            onTapDetail: () => _goToDetail(chanel),
            onTapEdit: () => _goToEdit(chanel),
            onTapHapus: () => _showDeleteConfirmation(context, chanel),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAdd,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}