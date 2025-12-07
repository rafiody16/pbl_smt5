import 'package:flutter/material.dart';
import '../../data/register_data.dart';

class StatusRumahField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? value;

  const StatusRumahField({super.key, this.onSaved, this.validator, this.value});

  @override
  State<StatusRumahField> createState() => _StatusRumahFieldState();
}

class _StatusRumahFieldState extends State<StatusRumahField> {
  String? _selectedStatusRumah;

  @override
  void initState() {
    super.initState();
    _selectedStatusRumah = widget.value;
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Status kepemilikan rumah harus dipilih';
    }
    return null;
  }

  // reset state
  void resetState() {
    setState(() {
      _selectedStatusRumah = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Status kepemilikan rumah"),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: _selectedStatusRumah,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Pilih Status",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
              items: RegisterData.statusRumahList.map((String item) {
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
                  _selectedStatusRumah = newValue;
                });
                widget.onSaved?.call(newValue);
              },
              validator: widget.validator ?? _defaultValidator,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorStyle: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
