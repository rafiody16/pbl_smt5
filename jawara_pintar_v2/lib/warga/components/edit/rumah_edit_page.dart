import 'package:flutter/material.dart';
import '../../components/form/form_rumah.dart';
import '../../../../services/toast_service.dart';
import '../../../../data/rumah_data.dart';

class RumahEditPage extends StatefulWidget {
  final Map<String, dynamic> rumah;

  const RumahEditPage({
    super.key,
    required this.rumah,
  });

  @override
  State<RumahEditPage> createState() => _RumahEditPageState();
}

class _RumahEditPageState extends State<RumahEditPage> {
  final _formKey = GlobalKey<FormState>();

  late String _alamat;
  late String _status;

  @override
  void initState() {
    super.initState();
    _alamat = widget.rumah['alamat'] ?? '';
    _status = widget.rumah['status'] ?? 'Tersedia';
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // TODO: simpan data ke database atau state management
      print('Data rumah disimpan:');
      print('Alamat: $_alamat');
      print('Status: $_status');

      ToastService.showSuccess(context, "Data rumah berhasil diperbarui");

      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pop();
      });
    }
  }

  Map<String, dynamic> get _formData {
    return {
      'alamat': _alamat,
      'status': _status,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Rumah",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.edit, color: Colors.blue, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Edit Rumah",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 24),

                    FormRumah(
                      initialData: _formData,
                      formKey: _formKey,
                      onAlamatChanged: (value) => _alamat = value,
                      onStatusChanged: (value) => setState(() => _status = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}