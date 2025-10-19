import 'package:flutter/material.dart';

class ActionButtonsPenerimaan extends StatelessWidget {
  final VoidCallback onDetail;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback? onActivate;
  final VoidCallback? onDeactivate;
  final String status;

  const ActionButtonsPenerimaan({
    super.key,
    required this.onDetail,
    required this.onApprove,
    required this.onReject,
    this.onActivate,
    this.onDeactivate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
      itemBuilder: (BuildContext context) {
        final items = <PopupMenuEntry<String>>[];

        items.add(
          const PopupMenuItem<String>(
            value: 'detail',
            child: Row(
              children: [
                SizedBox(width: 8),
                Text('Detail'),
              ],
            ),
          ),
        );

        if (status == 'Pending') {
          items.add(const PopupMenuDivider());
          
          items.add(
            const PopupMenuItem<String>(
              value: 'approve',
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Text('Setujui'),
                ],
              ),
            ),
          );
          
          items.add(
            const PopupMenuItem<String>(
              value: 'reject',
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Text('Tolak'),
                ],
              ),
            ),
          );
        }

        if (status == 'Nonaktif') {
          items.add(const PopupMenuDivider());
          
          items.add(
            const PopupMenuItem<String>(
              value: 'activate',
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Text('Aktifkan'),
                ],
              ),
            ),
          );
        }

        if (status == 'Diterima') {
          items.add(const PopupMenuDivider());
          
          items.add(
            const PopupMenuItem<String>(
              value: 'deactivate',
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Text('Nonaktifkan'),
                ],
              ),
            ),
          );
        }

        return items;
      },
      onSelected: (String value) {
        switch (value) {
          case 'detail':
            onDetail();
            break;
          case 'approve':
            onApprove();
            break;
          case 'reject':
            onReject();
            break;
          case 'activate':
            onActivate?.call();
            break;
          case 'deactivate':
            onDeactivate?.call();
            break;
        }
      },
      offset: const Offset(0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}