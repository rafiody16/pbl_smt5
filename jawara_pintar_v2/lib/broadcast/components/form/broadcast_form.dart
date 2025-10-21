import 'package:flutter/material.dart';
import '../../../data/data_broadcast.dart';

class FormBroadcast extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final GlobalKey<FormState> formKey;
  final Function(String) onJudulChanged;
  final Function(String) onIsiPesanChanged;
  final Function(String) onTanggalPublikasiChanged;
  final Function(String) onDibuatOlehChanged;
  final Function(String) onLampiranGambarChanged;
  final Function(String) onLampiranDokumenChanged;

  const FormBroadcast({
    super.key,
    required this.initialData,
    required this.formKey,
    required this.onJudulChanged,
    required this.onIsiPesanChanged,
    required this.onTanggalPublikasiChanged,
    required this.onDibuatOlehChanged,
    required this.onLampiranGambarChanged,
    required this.onLampiranDokumenChanged,
  });

  @override
  State<FormBroadcast> createState() => _FormBroadcastState();
}

class _FormBroadcastState extends State<FormBroadcast> {
  late TextEditingController _judulController;
  late TextEditingController _isiPesanController;
  late TextEditingController _tanggalPublikasiController;
  late TextEditingController _dibuatOlehController;
  late TextEditingController _lampiranGambarController;
  late TextEditingController _lampiranDokumenController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(
      text: widget.initialData['judul'] ?? '',
    );
    _isiPesanController = TextEditingController(
      text: widget.initialData['isi_pesan'] ?? '',
    );
    _tanggalPublikasiController = TextEditingController(
      text: widget.initialData['tanggal_publikasi'] ?? '',
    );
    _dibuatOlehController = TextEditingController(
      text: widget.initialData['dibuat_oleh'] ?? '',
    );
    _lampiranGambarController = TextEditingController(
      text: widget.initialData['lampiran_gambar'] ?? '',
    );
    _lampiranDokumenController = TextEditingController(
      text: widget.initialData['lampiran_dokumen'] ?? '',
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiPesanController.dispose();
    _tanggalPublikasiController.dispose();
    _dibuatOlehController.dispose();
    _lampiranGambarController.dispose();
    _lampiranDokumenController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      final formattedDate =
          "${picked.day} ${_getNamaBulan(picked.month)} ${picked.year}";
      setState(() {
        _tanggalPublikasiController.text = formattedDate;
      });
      widget.onTanggalPublikasiChanged(formattedDate);
    }
  }

  String _getNamaBulan(int bulan) {
    const bulanList = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return bulanList[bulan - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _judulController,
            decoration: const InputDecoration(
              labelText: 'Judul Broadcast',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => widget.onJudulChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _isiPesanController,
            decoration: const InputDecoration(
              labelText: 'Isi Pesan',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            onSaved: (value) => widget.onIsiPesanChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _tanggalPublikasiController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Tanggal Publikasi',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pilihTanggal(context),
              ),
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _dibuatOlehController,
            decoration: const InputDecoration(
              labelText: 'Dibuat Oleh',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => widget.onDibuatOlehChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _lampiranGambarController,
            decoration: const InputDecoration(
              labelText: 'Lampiran Gambar (nama file)',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.image),
            ),
            onSaved: (value) => widget.onLampiranGambarChanged(value ?? ''),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _lampiranDokumenController,
            decoration: const InputDecoration(
              labelText: 'Lampiran Dokumen (nama file)',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.picture_as_pdf),
            ),
            onSaved: (value) => widget.onLampiranDokumenChanged(value ?? ''),
          ),
        ],
      ),
    );
  }
}
