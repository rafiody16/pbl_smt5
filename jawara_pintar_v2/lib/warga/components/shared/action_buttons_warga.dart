import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onDetail;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final bool compact;

  const ActionButtons({
    super.key,
    required this.onDetail,
    required this.onEdit,
    this.onDelete,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactButtons();
    } else {
      return _buildFullButtons();
    }
  }

  Widget _buildFullButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailButton(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildEditButton(),
        ),
        if (onDelete != null) ...[
          const SizedBox(width: 8),
          _buildDeleteButton(),
        ],
      ],
    );
  }

  Widget _buildCompactButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIconButton(
          icon: Icons.remove_red_eye_outlined,
          color: Colors.blue,
          onPressed: onDetail,
          tooltip: 'Lihat Detail',
        ),
        _buildIconButton(
          icon: Icons.edit_outlined,
          color: Colors.green,
          onPressed: onEdit,
          tooltip: 'Edit Data',
        ),
        if (onDelete != null)
          _buildIconButton(
            icon: Icons.delete_outlined,
            color: Colors.red,
            onPressed: onDelete!,
            tooltip: 'Hapus Data',
          ),
      ],
    );
  }

  Widget _buildDetailButton() {
    return OutlinedButton.icon(
      onPressed: onDetail,
      icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
      label: const Text('Detail'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.blue.withOpacity(0.05),
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: onEdit,
      icon: const Icon(Icons.edit_outlined, size: 16),
      label: const Text('Edit'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1,
        shadowColor: Colors.green.withOpacity(0.3),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: onDelete,
        icon: Icon(Icons.delete_outlined, size: 20, color: Colors.red),
        padding: EdgeInsets.zero,
        tooltip: 'Hapus',
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: color),
        padding: EdgeInsets.zero,
        tooltip: tooltip,
      ),
    );
  }
}