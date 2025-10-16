import 'package:flutter/material.dart';
import '../../data/register_data.dart';

class RumahField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const RumahField({
    super.key,
    this.onSaved,
    this.validator,
  });

  @override
  State<RumahField> createState() => _RumahFieldState();
}

class _RumahFieldState extends State<RumahField> {
  String? _selectedRumah;

  String? _defaultValidator(String? value) {
    // opsional, karena ada validasi di form level
    return null;
  }

  // reset state
  void resetState() {
    setState(() {
      _selectedRumah = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Pilih Rumah yang Sudah Ada"),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _selectedRumah,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Pilih Rumah",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
              items: RegisterData.rumahList.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(item),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRumah = newValue;
                });
                widget.onSaved?.call(newValue);
              },
              validator: widget.validator ?? _defaultValidator,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pilih rumah atau isi alamat rumah.",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}