import 'package:flutter/material.dart';
import '../../../../data/warga_data.dart';
import 'list_content.dart';

class WargaList extends StatefulWidget {
  final Map<String, String> filters;
  final ScrollController scrollController;

  const WargaList({
    super.key,
    required this.filters,
    required this.scrollController,
  });

  @override
  State<WargaList> createState() => _WargaListState();
}

class _WargaListState extends State<WargaList> {
  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allWarga = WargaData.semuaDataWarga;

    if (widget.filters.isEmpty) return allWarga;

    return allWarga.where((warga) {
      if (widget.filters.containsKey('nama') &&
          widget.filters['nama']!.isNotEmpty &&
          !warga['nama'].toString().toLowerCase().contains(widget.filters['nama']!.toLowerCase())) {
        return false;
      }
      if (widget.filters.containsKey('jenis_kelamin') &&
          widget.filters['jenis_kelamin']!.isNotEmpty &&
          warga['jenis_kelamin'] != widget.filters['jenis_kelamin']) {
        return false;
      }
      if (widget.filters.containsKey('status') &&
          widget.filters['status']!.isNotEmpty &&
          warga['status_domisili'] != widget.filters['status']) {
        return false;
      }
      if (widget.filters.containsKey('keluarga') &&
          widget.filters['keluarga']!.isNotEmpty) {
        String? keluargaWarga = _getKeluargaFromWarga(warga);
        if (keluargaWarga != widget.filters['keluarga']) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  String? _getKeluargaFromWarga(Map<String, dynamic> warga) {
    for (var keluarga in WargaData.dataKeluarga) {
      var anggota = keluarga['anggota'] as List;
      var found = anggota.cast<Map<String, dynamic>>().firstWhere(
        (anggota) => anggota['nik'] == warga['nik'],
        orElse: () => <String, dynamic>{},
      );
      if (found.isNotEmpty) {
        return keluarga['nama_keluarga'] as String;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _filteredData;

    return ListContent(
      filteredData: filteredData,
      scrollController: widget.scrollController,
      totalWarga: filteredData.length, // Kirim total ke ListContent jika perlu
    );
  }
}