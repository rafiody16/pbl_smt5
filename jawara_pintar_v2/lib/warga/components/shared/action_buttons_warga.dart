import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onDetail;
  final VoidCallback onEdit;

  const ActionButtons({
    super.key,
    required this.onDetail,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'detail',
          child: Row(
            children: [
              SizedBox(width: 8),
              Text('Detail'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'detail') {
          onDetail();
        } else if (value == 'edit') {
          onEdit();
        }
      },
      offset: const Offset(0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}