import 'package:flutter/material.dart';
import '../../../services/toast_service.dart';

class PenerimaanWargaDialogService {
  static void showApproveDialog({
    required BuildContext context,
    required String nama,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setujui Pendaftaran'),
        content: Text('Apakah Anda yakin ingin menyetujui pendaftaran $nama?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
              ToastService.showSuccess(
                context, 
                'Pendaftaran $nama telah disetujui'
              );
            },
            child: const Text('Setujui'),
          ),
        ],
      ),
    );
  }

  static void showRejectDialog({
    required BuildContext context,
    required String nama,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Pendaftaran'),
        content: Text('Apakah Anda yakin ingin menolak pendaftaran $nama?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
              ToastService.showError(
                context, 
                'Pendaftaran $nama telah ditolak'
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  static void showActivateDialog({
    required BuildContext context,
    required String nama,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aktifkan Pendaftaran'),
        content: Text('Apakah Anda yakin ingin mengaktifkan pendaftaran $nama?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
              ToastService.showSuccess(
                context, 
                'Pendaftaran $nama telah diaktifkan'
              );
            },
            child: const Text('Aktifkan'),
          ),
        ],
      ),
    );
  }

  static void showDeactivateDialog({
    required BuildContext context,
    required String nama,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nonaktifkan Pendaftaran'),
        content: Text('Apakah Anda yakin ingin menonaktifkan pendaftaran $nama?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
              ToastService.showWarning(
                context, 
                'Pendaftaran $nama telah dinonaktifkan'
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Nonaktifkan'),
          ),
        ],
      ),
    );
  }

  static void showFotoIdentitasDialog({
    required BuildContext context,
    required String nama,
    required String fotoIdentitas,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.blue,
                child: Row(
                  children: [
                    const Icon(Icons.photo, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Foto Identitas - $nama',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/images/$fotoIdentitas',
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 300,
                      height: 200,
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo, size: 64, color: Colors.grey[400]),
                          Text(
                            'Foto tidak tersedia',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}