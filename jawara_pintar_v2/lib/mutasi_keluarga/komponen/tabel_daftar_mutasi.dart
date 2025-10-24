import 'package:flutter/material.dart';
import '../../../model/mutasi.dart';

class MutasiListTable extends StatelessWidget {
  final List<Mutasi> mutasiList;
  final Function(Mutasi) onDetailTap;

  const MutasiListTable({
    super.key,
    required this.mutasiList,
    required this.onDetailTap,
  });

  // Widget kecil untuk status chip
  Widget _buildStatusChip(String jenisMutasi) {
    Color chipColor;
    Color textColor;

    if (jenisMutasi == 'Keluar Wilayah') {
      chipColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
    } else {
      chipColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    }

    return Chip(
      label: Text(
        jenisMutasi,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tombol Filter di bagian atas
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Tambahkan logika filter
                },
                icon: const Icon(Icons.filter_list, size: 18),
                label: const Text("Filter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Daftar data mutasi (tanpa tabel horizontal)
            ...mutasiList.asMap().entries.map((entry) {
              int index = entry.key;
              Mutasi mutasi = entry.value;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple[100],
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    mutasi.namaKeluarga,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mutasi.tanggal,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      _buildStatusChip(mutasi.jenisMutasi),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'detail') onDetailTap(mutasi);
                    },
                    itemBuilder: (BuildContext context) => const [
                      PopupMenuItem<String>(
                        value: 'detail',
                        child: Text('Detail'),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Paginasi (mockup)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {},
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
