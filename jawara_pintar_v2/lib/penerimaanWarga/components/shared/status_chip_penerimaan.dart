import 'package:flutter/material.dart';

class StatusChipPenerimaan extends StatelessWidget {
  final String status;

  const StatusChipPenerimaan({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'diterima':
        backgroundColor = const Color(0xFFE8F5E8);
        textColor = const Color(0xFF2E7D32);
        break;
      case 'pending':
        backgroundColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57F17);
        break;
      case 'nonaktif':
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[600]!;
        break;
      default:
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}