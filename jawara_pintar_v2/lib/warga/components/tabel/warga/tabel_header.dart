import 'package:flutter/material.dart';

class TabelHeader extends StatelessWidget {
  final int totalWarga;

  const TabelHeader({
    super.key,
    required this.totalWarga,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.people_alt, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        const Text(
          "Daftar Warga",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          "Total: $totalWarga warga",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}