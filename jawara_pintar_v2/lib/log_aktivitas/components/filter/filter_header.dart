import 'package:flutter/material.dart';

class FilterHeader extends StatelessWidget {
  final VoidCallback onClose;

  const FilterHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.filter_list, color: Colors.blue, size: 24),
        const SizedBox(width: 8),
        const Text(
          "Filter Log Aktivitas",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        IconButton(icon: const Icon(Icons.close, size: 20), onPressed: onClose),
      ],
    );
  }
}
