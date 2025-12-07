import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TanggalLahirField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? initialValue;

  const TanggalLahirField({super.key, this.onSaved, this.initialValue});

  @override
  State<TanggalLahirField> createState() => _TanggalLahirFieldState();
}

class _TanggalLahirFieldState extends State<TanggalLahirField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // 3. Logika pengisian nilai awal
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _controller.text = widget.initialValue!;
      try {
        _selectedDate = DateTime.parse(widget.initialValue!);
      } catch (e) {
        // Abaikan error parsing jika format salah
      }
    }
  }

  void resetState() {
    setState(() {
      _controller.clear();
      _selectedDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 17)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: const InputDecoration(
        labelText: "Tanggal Lahir",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),
        hintText: "YYYY-MM-DD",
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Tanggal lahir wajib diisi";
        }
        return null;
      },
      onSaved: widget.onSaved,
    );
  }
}
