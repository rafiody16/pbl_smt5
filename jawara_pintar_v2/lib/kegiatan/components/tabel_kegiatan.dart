import 'package:flutter/material.dart';
import '../../../../data/kegiatan_data.dart';
import 'tabel_content.dart';
import 'package:intl/intl.dart';

class KegiatanList extends StatefulWidget {
  final Map<String, String> filters;
  final ScrollController scrollController;

  const KegiatanList({
    super.key,
    required this.filters,
    required this.scrollController,
  });

  @override
  State<KegiatanList> createState() => _KegiatanListState();
}

class _KegiatanListState extends State<KegiatanList> {
  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allKegiatan = KegiatanData.semuaDataKegiatan;

    if (widget.filters.isEmpty) return allKegiatan;

    return allKegiatan.where((kegiatan) {
      if (widget.filters.containsKey('nama') &&
          widget.filters['nama']!.isNotEmpty &&
          !kegiatan['nama'].toString().toLowerCase().contains(
            widget.filters['nama']!.toLowerCase(),
          )) {
        return false;
      }

      if (widget.filters.containsKey('kategori') &&
          widget.filters['kategori']!.isNotEmpty &&
          kegiatan['kategori'] != widget.filters['kategori']) {
        return false;
      }

      if (widget.filters.containsKey('tanggal') &&
          widget.filters['tanggal']!.isNotEmpty) {
        try {
          DateTime kegiatanDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(kegiatan['tanggal']);
          DateTime filterDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(widget.filters['tanggal']!);

          if (kegiatanDate != filterDate) return false;
        } catch (e) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _filteredData;

    return ListContent(
      filteredData: filteredData,
      scrollController: widget.scrollController,
      totalKegiatan: filteredData.length,
    );
  }
}
