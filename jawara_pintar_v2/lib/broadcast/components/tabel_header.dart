import 'package:flutter/material.dart';

class TabelHeaderBroadcast extends StatelessWidget {
  final int totalBroadcast;

  const TabelHeaderBroadcast({super.key, required this.totalBroadcast});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.announcement, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        const Text(
          "Daftar Broadcast",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          "Total: $totalBroadcast broadcast",
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}
