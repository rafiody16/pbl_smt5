import 'package:flutter/material.dart';

class ActionButtonsKeluarga extends StatelessWidget {
  final VoidCallback onDetail;

  const ActionButtonsKeluarga({
    super.key,
    required this.onDetail,
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
      ],
      onSelected: (String value) {
        if (value == 'detail') {
          onDetail();
        }
      },
      offset: const Offset(0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}