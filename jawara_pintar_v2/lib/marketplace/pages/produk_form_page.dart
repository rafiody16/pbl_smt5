import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/produk_provider.dart';
import '../../services/toast_service.dart';

class ProdukFormPage extends StatefulWidget {
  final Map<String, dynamic>? existingProduk; // Jika null berarti mode Tambah

  const ProdukFormPage({Key? key, this.existingProduk}) : super(key: key);

  @override
  State<ProdukFormPage> createState() => _ProdukFormPageState();
}

class _ProdukFormPageState extends State<ProdukFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;

  // State Variables
  String? _selectedKategori;
  bool _isActive = true;
  File? _imageFile;
  String? _currentImageUrl;

  // Data Kategori
  final List<String> _kategoriList = [
    'Makanan',
    'Minuman',
    'Kerajinan',
    'Jasa',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.existingProduk?['nama_produk'] ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.existingProduk?['deskripsi'] ?? '',
    );
    _hargaController = TextEditingController(
      text: widget.existingProduk?['harga']?.toString() ?? '',
    );
    _stokController = TextEditingController(
      text: widget.existingProduk?['stok']?.toString() ?? '',
    );

    if (widget.existingProduk != null) {
      _selectedKategori = widget.existingProduk?['kategori'];
      _isActive = widget.existingProduk?['is_active'] ?? true;
      _currentImageUrl = widget.existingProduk?['gambar_url'];

      // Validasi agar kategori yang ada di database sesuai dengan list dropdown
      if (!_kategoriList.contains(_selectedKategori)) {
        _selectedKategori = 'Lainnya';
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  // --- Logic Image Picker ---
  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 60,
        maxWidth: 1024, // Resize agar upload lebih cepat
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      ToastService.showError(context, "Gagal mengambil gambar");
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.blue),
            title: const Text('Ambil Foto (Kamera)'),
            onTap: () {
              Navigator.pop(ctx);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.green),
            title: const Text('Pilih dari Galeri'),
            onTap: () {
              Navigator.pop(ctx);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  // --- Logic Submit ---
  // --- Logic Submit (Updated) ---
  Future<void> _submitForm() async {
    // 1️⃣ Validasi Form
    if (!_formKey.currentState!.validate()) {
      ToastService.showWarning(context, "Mohon lengkapi data formulir");
      return;
    }

    final provider = context.read<ProdukProvider>();
    final nav = Navigator.of(context);

    // 2️⃣ Loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        Navigator.of(context, rootNavigator: true).pop();
        ToastService.showError(context, "User belum login");
        return;
      }

      // DEBUG (boleh dihapus setelah yakin)
      debugPrint("USER METADATA: ${user.userMetadata}");

      final dynamic nikRaw = user.userMetadata?['nik'];
      final String? sellerNik = nikRaw?.toString();

      debugPrint("SELLER NIK: $sellerNik");

      if (sellerNik == null || sellerNik.trim().isEmpty) {
        Navigator.of(context, rootNavigator: true).pop();
        ToastService.showError(
          context,
          "Profil Anda belum memiliki data NIK yang valid.",
        );
        return;
      }

      final hargaRaw = _hargaController.text
          .replaceAll('.', '')
          .replaceAll(',', '');
      final harga = int.tryParse(hargaRaw) ?? 0;
      final stok = int.tryParse(_stokController.text) ?? 0;

      final Map<String, dynamic> data = {
        'seller_nik': sellerNik, // ⬅️ FIXED
        'nama_produk': _namaController.text.trim(),
        'deskripsi': _deskripsiController.text.trim(),
        'harga': harga,
        'stok': stok,
        'kategori': _selectedKategori ?? 'Lainnya',
        'is_active': _isActive,
      };

      bool success;
      if (widget.existingProduk != null) {
        success = await provider.updateProduk(
          widget.existingProduk!['id'],
          data,
          imageFile: _imageFile,
        );
      } else {
        success = await provider.tambahProduk(data, imageFile: _imageFile);
      }

      // Tutup loading
      Navigator.of(context, rootNavigator: true).pop();

      if (success) {
        ToastService.showSuccess(
          context,
          widget.existingProduk != null
              ? "Produk berhasil diperbarui"
              : "Produk berhasil ditambahkan",
        );

        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/marketplace/list',
          (route) => route.isFirst || route.settings.name == '/dashboard',
        );
      } else {
        ToastService.showError(
          context,
          provider.errorMessage ?? "Gagal menyimpan produk",
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ToastService.showError(context, "Terjadi kesalahan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingProduk != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Produk' : 'Tambah Produk Baru',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          // PERBAIKAN: Navigasi Back menuju Dashboard
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false, // Menghapus semua stack route sebelumnya
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Section Foto Produk ---
                _buildImagePickerSection(),

                const SizedBox(height: 24),

                // --- Container Form Input ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _namaController,
                        label: "Nama Produk",
                        hint: "Contoh: Keripik Pisang",
                        icon: Icons.shopping_bag_outlined,
                        validator: (val) => val == null || val.isEmpty
                            ? "Nama produk wajib diisi"
                            : null,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTextField(
                              controller: _hargaController,
                              label: "Harga (Rp)",
                              hint: "0",
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (val) => val == null || val.isEmpty
                                  ? "Wajib diisi"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _stokController,
                              label: "Stok",
                              hint: "0",
                              icon: Icons.inventory_2_outlined,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedKategori,
                        decoration: InputDecoration(
                          labelText: "Kategori",
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        hint: const Text("Pilih Kategori"),
                        items: _kategoriList.map((kat) {
                          return DropdownMenuItem(value: kat, child: Text(kat));
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => _selectedKategori = val),
                        validator: (val) =>
                            val == null ? "Pilih kategori" : null,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _deskripsiController,
                        label: "Deskripsi",
                        hint: "Jelaskan detail produk Anda...",
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // ✅ SOLUSI: Gunakan Row dan Switch biasa
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Status Aktif",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Tampilkan produk ini di katalog?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isActive,
                            onChanged: (val) => setState(() => _isActive = val),
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    isEdit ? "Simpan Perubahan" : "Simpan Produk",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Helper ---

  Widget _buildImagePickerSection() {
    return Center(
      child: GestureDetector(
        onTap: _showImageSourceDialog,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              style:
                  BorderStyle.solid, // PERBAIKAN: diganti dari dashed ke solid
              width: 2,
            ),
            image: _imageFile != null
                ? DecorationImage(
                    image: FileImage(_imageFile!),
                    fit: BoxFit.cover,
                  )
                : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_currentImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null),
          ),
          child:
              _imageFile == null &&
                  (_currentImageUrl == null || _currentImageUrl!.isEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 48,
                      color: Colors.blueGrey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Ketuk untuk tambah foto",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
