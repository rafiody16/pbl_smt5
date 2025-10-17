import 'package:flutter/material.dart';

class PendidikanField extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  final List<String> _pendidikanList = ['-- Pilih Pendidikan --', 'SD', 'SMP', 'SMA', 'D3', 'S1', 'S2', 'S3'];

  PendidikanField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pendidikan Terakhir',
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
                value: value.isNotEmpty ? value : _pendidikanList.first,
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.arrow_drop_down, color: Colors.grey),
                ),
                items: _pendidikanList.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: item.startsWith('--') ? Colors.grey : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) => onChanged(value!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}