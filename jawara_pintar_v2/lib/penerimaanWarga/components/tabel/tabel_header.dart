import 'package:flutter/material.dart';

class TabelHeaderPenerimaan extends StatelessWidget {
  final int totalPendaftaran;

  const TabelHeaderPenerimaan({
    super.key,
    required this.totalPendaftaran,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person_add, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        const Text(
          "Daftar Pendaftaran Warga",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          "Total: $totalPendaftaran pendaftaran",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}