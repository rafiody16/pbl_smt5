import 'package:flutter/material.dart';

class TabelHeader extends StatelessWidget {
  final int totalKeluarga;

  const TabelHeader({
    super.key,
    required this.totalKeluarga,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.family_restroom, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        const Text(
          "Daftar Keluarga",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          "Total: $totalKeluarga keluarga",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}