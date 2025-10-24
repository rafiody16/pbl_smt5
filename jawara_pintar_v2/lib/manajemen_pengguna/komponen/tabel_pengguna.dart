import 'package:flutter/material.dart';
import '../../../model/pengguna.dart';
import '../halaman_detail_pengguna.dart';
import '../halaman_edit_pengguna.dart';

class UserTable extends StatelessWidget {
  final List<User> users;

  const UserTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users.map((user) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple[200],
              child: Text(
                user.id.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(user.email,
                    style: const TextStyle(fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.registrationStatus,
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
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
                      builder: (context) => UserEditScreen(user: user),
                    ),
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'detail', child: Text('Detail')),
                PopupMenuItem(value: 'edit', child: Text('Edit')),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ),
        );
      }).toList(),
    );
  }
}
