import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final bool compact;

  const StatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, textColor, icon) = _getStatusInfo(status);
    
    return Container(
      padding: compact 
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: textColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: compact ? 10 : 12,
              color: textColor,
            ),
            SizedBox(width: compact ? 2 : 4),
          ],
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, IconData?) _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return (const Color(0xFFE8F5E8), const Color(0xFF2E7D32), Icons.check_circle);
      case 'hidup':
        return (const Color(0xFFE8F5E8), const Color(0xFF2E7D32), Icons.favorite);
      case 'nonaktif':
        return (Colors.grey[100]!, Colors.grey[600]!, Icons.cancel);
      case 'meninggal':
        return (const Color(0xFFFFEBEE), const Color(0xFFC62828), Icons.heart_broken);
      case 'tersedia':
        return (const Color(0xFFE8F5E8), const Color(0xFF2E7D32), Icons.event_available);
      case 'ditempati':
        return (const Color(0xFFE3F2FD), const Color(0xFF1565C0), Icons.home);
      case 'domisili tetap':
        return (const Color(0xFFE8F5E8), const Color(0xFF2E7D32), Icons.home);
      case 'domisili sementara':
        return (const Color(0xFFFFF8E1), const Color(0xFFF57C00), Icons.schedule);
      case 'pindah':
        return (const Color(0xFFFFEBEE), const Color(0xFFC62828), Icons.exit_to_app);
      default:
        return (const Color(0xFFF3E5F5), const Color(0xFF7B1FA2), Icons.help_outline);
    }
  }
}