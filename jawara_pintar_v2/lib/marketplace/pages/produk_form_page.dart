import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk input formatter angka
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import '../../../providers/produk_provider.dart'; // Sesuaikan import provider Anda
// import '../../../services/toast_service.dart'; // Sesuaikan import service Anda

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
  String? _currentImageUrl; // Untuk menampung URL gambar jika mode edit

  // Mock Data Kategori (Bisa diganti dari API)
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
    // Inisialisasi Controller & Data jika Edit
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
        imageQuality: 50, // Kompresi agar tidak terlalu besar
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      // ToastService.showError(context, "Gagal mengambil gambar");
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
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Loading State
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Siapkan Data
      // Catatan: seller_nik biasanya diambil dari User Session / SharedPrefs
      String sellerNik = "1234567890123456"; // GANTI DENGAN SESSION USER ASLI

      Map<String, dynamic> data = {
        'seller_nik': sellerNik,
        'nama_produk': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'harga': int.parse(_hargaController.text), // Sesuai tipe numeric/bigint
        'stok': int.tryParse(_stokController.text) ?? 0,
        'kategori': _selectedKategori,
        'is_active': _isActive,
        // 'gambar_path': _imageFile?.path // Kirim path file ke provider untuk diupload
      };

      // 2. Panggil Provider
      // final provider = context.read<ProdukProvider>();
      // bool success;

      // if (widget.existingProduk == null) {
      //   success = await provider.tambahProduk(data, imageFile: _imageFile);
      // } else {
      //   success = await provider.updateProduk(widget.existingProduk!['id'], data, imageFile: _imageFile);
      // }

      // MOCK SUKSES (Hapus bagian ini jika Provider sudah siap)
      await Future.delayed(const Duration(seconds: 2));
      bool success = true;

      Navigator.pop(context); // Tutup Loading

      if (success) {
        // ToastService.showSuccess(context, "Produk berhasil disimpan");
        Navigator.pop(context); // Kembali ke list
      } else {
        // ToastService.showError(context, "Gagal menyimpan produk");
      }
    } catch (e) {
      Navigator.pop(context); // Tutup Loading
      // ToastService.showError(context, "Terjadi kesalahan: $e");
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                      ),
                      items: _kategoriList.map((kat) {
                        return DropdownMenuItem(value: kat, child: Text(kat));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedKategori = val),
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

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Status Aktif"),
                      subtitle: const Text("Tampilkan produk ini di katalog?"),
                      value: _isActive,
                      onChanged: (val) => setState(() => _isActive = val),
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
                ),
                child: const Text(
                  "Simpan Produk",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
            ),
            image: _imageFile != null
                ? DecorationImage(
                    image: FileImage(_imageFile!),
                    fit: BoxFit.cover,
                  )
                : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(
                            _currentImageUrl!,
                          ), // Ganti NetworkImage jika pakai Supabase Storage
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
                    Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      "Tambah Foto Produk",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
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
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
