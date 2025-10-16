import 'package:flutter/material.dart';

class ToastService {
  static void showSuccess(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      Colors.green,
      Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      Colors.red,
      Icons.error,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      Colors.orange,
      Icons.warning,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      Colors.blue,
      Icons.info,
    );
  }

  static void _showCustomToast(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData icon,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () {
                    overlayEntry.remove();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}