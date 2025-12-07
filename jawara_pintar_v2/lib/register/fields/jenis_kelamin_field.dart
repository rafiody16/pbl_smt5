import 'package:flutter/material.dart';
import '../../data/register_data.dart';

class JenisKelaminField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? value;

  const JenisKelaminField({
    super.key,
    this.onSaved,
    this.validator,
    this.value,
  });

  @override
  State<JenisKelaminField> createState() => _JenisKelaminFieldState();
}

class _JenisKelaminFieldState extends State<JenisKelaminField> {
  String? _selectedJenisKelamin;

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jenis kelamin harus dipilih';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selectedJenisKelamin = widget.value;
  }

  // reset state
  void resetState() {
    setState(() {
      _selectedJenisKelamin = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Jenis Kelamin"),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: _selectedJenisKelamin,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Pilih Jenis Kelamin",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
              items: RegisterData.jenisKelaminList.map((String item) {
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
                  _selectedJenisKelamin = newValue;
                });
                widget.onSaved?.call(newValue);
              },
              validator: widget.validator ?? _validate,
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
