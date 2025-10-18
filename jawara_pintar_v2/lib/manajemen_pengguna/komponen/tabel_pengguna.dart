// lib/halaman/manajemen_pengguna/komponen/tabel_pengguna.dart

import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/manajemen_pengguna/komponen/form_edit_pengguna.dart';
import '../../../model/pengguna.dart';
import '../halaman_detail_pengguna.dart';

class UserTable extends StatelessWidget {
  final List<User> users;

  const UserTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DataTable(
          // ... (Isi DataTable seperti kode sebelumnya)
          columns: const [
            DataColumn(label: Text('NO')),
            DataColumn(label: Text('NAMA')),
            DataColumn(label: Text('EMAIL')),
            DataColumn(label: Text('STATUS')),
            DataColumn(label: Text('AKSI')),
          ],
          rows: users.map((user) {
            return DataRow(cells: [
              DataCell(Text(user.id.toString())),
              DataCell(Text(user.name)),
              DataCell(Text(user.email)),
              DataCell(
                Container(
                  // ... styling status ...
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.registrationStatus,
                    style: TextStyle(color: Colors.green[800], fontSize: 12),
                  ),
                ),
              ),
              DataCell(
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'detail') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(user: user),
                        ),
                      );
                    }
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserEditForm(user: user),
                        ),
                      );
                    }
                  },
                  
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'detail', child: Text('Detail')),
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  ],
                  icon: const Icon(Icons.more_horiz),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}