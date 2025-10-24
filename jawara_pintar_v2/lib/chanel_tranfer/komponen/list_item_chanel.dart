import 'package:flutter/material.dart';
import '../../../model/chanel_transfer.dart';

class ListItemChanel extends StatelessWidget {
  final ChanelTransfer chanel;
  final VoidCallback onTapDetail;
  final VoidCallback onTapEdit;
  final VoidCallback onTapHapus;

  const ListItemChanel({
    super.key,
    required this.chanel,
    required this.onTapDetail,
    required this.onTapEdit,
    required this.onTapHapus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        // --- THUMBNAIL ---
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: chanel.thumbnailUrl != null
              ? Image.network(
                  chanel.thumbnailUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  // Error builder jika link gambar rusak
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50),
                )
              : Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                  child: const Icon(Icons.account_balance, color: Colors.grey),
                ),
        ),
        // --- NAMA & TIPE ---
        title: Text(
          chanel.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chanel.tipe.toUpperCase()),
            Text("A/N: ${chanel.namaPemilik}"),
          ],
        ),
        // --- TOMBOL AKSI ---
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'detail') onTapDetail();
            if (value == 'edit') onTapEdit();
            if (value == 'hapus') onTapHapus();
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(value: 'detail', child: Text('Detail')),
            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            const PopupMenuItem<String>(value: 'hapus', child: Text('Hapus')),
          ],
          icon: const Icon(Icons.more_vert),
        ),
        onTap: onTapDetail, // Klik di mana saja akan membuka detail
      ),
    );
  }
}