import 'package:flutter/material.dart';
import '../data/register_data.dart';

class RegisterFormBawah extends StatefulWidget {
  const RegisterFormBawah({super.key});

  @override
  State<RegisterFormBawah> createState() => _RegisterFormPart2State();
}

class _RegisterFormPart2State extends State<RegisterFormBawah> {
  String? _selectedJenisKelamin;
  String? _selectedRumah;
  String? _selectedStatusRumah;

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(label),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String hint, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(label),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  hint,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(item),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Foto Identitas"),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Aksi upload foto
          },
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // Icon(
                //   Icons.cloud_upload_outlined,
                //   color: Colors.blue,
                //   size: 32,
                // ),
                SizedBox(height: 8),
                Text(
                  "Upload foto KK/KTP (.png/jpg)",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Powered by PQINA",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(
          "Jenis Kelamin",
          "Pilih Jenis Kelamin",
          _selectedJenisKelamin,
          RegisterData.jenisKelaminList,
          (newValue) {
            setState(() {
              _selectedJenisKelamin = newValue;
            });
          },
        ),
        const SizedBox(height: 16),

        _buildDropdown(
          "Pilih Rumah yang Sudah Ada",
          "Pilih Rumah",
          _selectedRumah,
          RegisterData.rumahList,
          (newValue) {
            setState(() {
              _selectedRumah = newValue;
            });
          },
        ),
        const SizedBox(height: 8),
        Text(
          "Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),

        _buildTextField("Alamat Rumah (Jika Tidak Ada di List)", "Blok 5A / No.10"),
        const SizedBox(height: 16),

        _buildDropdown(
          "Status kepemilikan rumah",
          "Pilih Status",
          _selectedStatusRumah,
          RegisterData.statusRumahList,
          (newValue) {
            setState(() {
              _selectedStatusRumah = newValue;
            });
          },
        ),
        const SizedBox(height: 16),

        _buildUploadSection(),
      ],
    );
  }
}