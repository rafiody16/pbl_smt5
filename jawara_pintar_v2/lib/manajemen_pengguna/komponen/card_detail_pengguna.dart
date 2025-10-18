// lib/halaman/manajemen_pengguna/komponen/kartu_detail_pengguna.dart

import 'package:flutter/material.dart';
import '../../../model/pengguna.dart';
import '../halaman_edit_pengguna.dart';

class UserDetailCard extends StatelessWidget {
  final User user;

  const UserDetailCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildDetailRow('NIK:', user.nik ?? 'Tidak tersedia'),
            _buildDetailRow('Email:', user.email),
            _buildDetailRow('Nomor HP:', user.phoneNumber),
            _buildDetailRow('Jenis Kelamin:', user.gender ?? 'Tidak tersedia'),
            _buildDetailRow('Status Registrasi:', user.registrationStatus, color: Colors.green[800]),
            const SizedBox(height: 20),
            
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserEditScreen(user: user),
                    ),
                  );
                },
                child: const Text('Edit Pengguna'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}