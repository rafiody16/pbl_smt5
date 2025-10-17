import 'package:flutter/material.dart';

class TanggalLahirField extends StatelessWidget {
  final String value;
  final Function(String) onDateSelected;

  const TanggalLahirField({
    super.key,
    required this.value,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected("${picked.day}/${picked.month}/${picked.year}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tanggal Lahir',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    value.isNotEmpty ? value : '--/--/---',
                    style: TextStyle(
                      color: value.isNotEmpty ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}