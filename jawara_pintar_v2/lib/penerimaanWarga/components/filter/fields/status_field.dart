import 'package:flutter/material.dart';

class StatusPenerimaanField extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const StatusPenerimaanField({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Status",
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "-- Pilih Status --",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              items: const [
                DropdownMenuItem(
                  value: '',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Semua Status'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Diterima',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Diterima'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Pending',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pending'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Nonaktif',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Nonaktif'),
                  ),
                ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}