import 'package:flutter/material.dart';

class FilterHeaderPenerimaan extends StatelessWidget {
  const FilterHeaderPenerimaan({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.filter_list, color: Colors.blue, size: 24),
        const SizedBox(width: 8),
        const Text(
          "Filter Penerimaan Warga",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}