import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadIdentitasField extends StatefulWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? initialValue;

  const UploadIdentitasField({
    super.key,
    this.onSaved,
    this.validator,
    this.initialValue,
  });

  @override
  State<UploadIdentitasField> createState() => _UploadIdentitasFieldState();
}

class _UploadIdentitasFieldState extends State<UploadIdentitasField> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  // String? _defaultValidator(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Foto identitas wajib diunggah';
  //   }
  //   return null;
  // }

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialValue;
  }

  // reset state
  void resetState() {
    setState(() {
      _imagePath = null;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
        widget.onSaved?.call(image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Foto Identitas"),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _imagePath != null ? Colors.blue : Colors.grey.shade300,
              ),
            ),
            child: _imagePath != null
                ? Stack(
                    children: [
                      Center(
                        child: Image.network(
                          _imagePath!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  "Gambar tidak dapat dimuat",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                            onPressed: () {
                              setState(() {
                                _imagePath = null;
                              });
                              widget.onSaved?.call(null);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.grey,
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Upload foto KK/KTP (.png/jpg)",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
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
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
