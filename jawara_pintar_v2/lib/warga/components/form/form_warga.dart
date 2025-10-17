import 'package:flutter/material.dart';
import 'fields/nama_lengkap_field.dart';
import 'fields/nik_field.dart';
import 'fields/no_telepon_field.dart';
import 'fields/keluarga_field.dart';
import 'fields/tempat_lahir_field.dart';
import 'fields/tanggal_lahir_field.dart';
import 'fields/agama_field.dart';
import 'fields/golongan_darah_field.dart';
import 'fields/peran_field.dart';
import 'fields/pendidikan_field.dart';
import 'fields/pekerjaan_field.dart';
import 'fields/status_hidup_field.dart';
import 'fields/status_penduduk_field.dart';
import 'fields/jenis_kelamin_field.dart';

class FormWarga extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final GlobalKey<FormState> formKey;
  final Function(String) onNamaChanged;
  final Function(String) onNikChanged;
  final Function(String) onNoTeleponChanged;
  final Function(String) onKeluargaChanged;
  final Function(String) onTempatLahirChanged;
  final Function(String) onTanggalLahirChanged;
  final Function(String) onAgamaChanged;
  final Function(String) onGolonganDarahChanged;
  final Function(String) onPeranChanged;
  final Function(String) onPendidikanChanged;
  final Function(String) onPekerjaanChanged;
  final Function(String) onStatusHidupChanged;
  final Function(String) onStatusPendudukChanged;
  final Function(String) onJenisKelaminChanged;

  const FormWarga({
    super.key,
    required this.initialData,
    required this.formKey,
    required this.onNamaChanged,
    required this.onNikChanged,
    required this.onNoTeleponChanged,
    required this.onKeluargaChanged,
    required this.onTempatLahirChanged,
    required this.onTanggalLahirChanged,
    required this.onAgamaChanged,
    required this.onGolonganDarahChanged,
    required this.onPeranChanged,
    required this.onPendidikanChanged,
    required this.onPekerjaanChanged,
    required this.onStatusHidupChanged,
    required this.onStatusPendudukChanged,
    required this.onJenisKelaminChanged,
  });

  @override
  State<FormWarga> createState() => _FormWargaState();
}

class _FormWargaState extends State<FormWarga> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NamaLengkapField(
            initialValue: widget.initialData['nama'] ?? '',
            onSaved: (value) => widget.onNamaChanged(value ?? ''),
          ),
          NikField(
            initialValue: widget.initialData['nik'] ?? '',
            onSaved: (value) => widget.onNikChanged(value ?? ''),
          ),
          NoTeleponField(
            initialValue: widget.initialData['no_telepon'] ?? '',
            onSaved: (value) => widget.onNoTeleponChanged(value ?? ''),
          ),
          KeluargaField(
            value: widget.initialData['keluarga'] ?? '',
            onChanged: widget.onKeluargaChanged,
          ),
          TempatLahirField(
            initialValue: widget.initialData['tempat_lahir'] ?? '',
            onSaved: (value) => widget.onTempatLahirChanged(value ?? ''),
          ),
          TanggalLahirField(
            value: widget.initialData['tanggal_lahir'] ?? '',
            onDateSelected: widget.onTanggalLahirChanged,
          ),
          AgamaField(
            value: widget.initialData['agama'] ?? '',
            onChanged: widget.onAgamaChanged,
          ),
          GolonganDarahField(
            value: widget.initialData['golongan_darah'] ?? '',
            onChanged: widget.onGolonganDarahChanged,
          ),
          PeranField(
            value: widget.initialData['peran'] ?? 'Kepala Keluarga',
            onChanged: widget.onPeranChanged,
          ),
          PendidikanField(
            value: widget.initialData['pendidikan'] ?? '',
            onChanged: widget.onPendidikanChanged,
          ),
          PekerjaanField(
            value: widget.initialData['pekerjaan'] ?? '',
            onChanged: widget.onPekerjaanChanged,
          ),
          StatusHidupField(
            value: widget.initialData['status_hidup'] ?? 'Hidup',
            onChanged: widget.onStatusHidupChanged,
          ),
          StatusPendudukField(
            value: widget.initialData['status_domisili'] ?? 'Aktif',
            onChanged: widget.onStatusPendudukChanged,
          ),
          JenisKelaminField(
            value: widget.initialData['jenis_kelamin'] ?? 'Laki-laki',
            onChanged: widget.onJenisKelaminChanged,
          ),
        ],
      ),
    );
  }
}