import 'package:flutter/material.dart';

class TabelHeaderRumah extends StatelessWidget {
  final int totalRumah;

  const TabelHeaderRumah({
    super.key,
    required this.totalRumah,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.house, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        const Text(
          "Daftar Rumah",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          "Total: $totalRumah rumah",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}