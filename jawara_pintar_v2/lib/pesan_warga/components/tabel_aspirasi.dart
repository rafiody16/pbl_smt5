import 'package:flutter/material.dart';
import '../../../../data/data_aspirasi.dart';
import 'tabel_content.dart';
import 'package:intl/intl.dart';

class AspirasiList extends StatefulWidget {
  final Map<String, String> filters;
  final ScrollController scrollController;

  const AspirasiList({
    super.key,
    required this.filters,
    required this.scrollController,
  });

  @override
  State<AspirasiList> createState() => _AspirasiListState();
}

class _AspirasiListState extends State<AspirasiList> {
  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allAspirasi = DataAspirasi.dataAspirasi;

    if (widget.filters.isEmpty) return allAspirasi;

    return allAspirasi.where((aspirasi) {
      if (widget.filters.containsKey('dibuat_oleh') &&
          widget.filters['dibuat_oleh']!.isNotEmpty &&
          !aspirasi['dibuat_oleh'].toString().toLowerCase().contains(
            widget.filters['dibuat_oleh']!.toLowerCase(),
          )) {
        return false;
      }

      if (widget.filters.containsKey('judul') &&
          widget.filters['judul']!.isNotEmpty &&
          aspirasi['judul'] != widget.filters['judul']) {
        return false;
      }

      if (widget.filters.containsKey('status') &&
          widget.filters['status']!.isNotEmpty &&
          aspirasi['status'] != widget.filters['status']) {
        return false;
      }

      if (widget.filters.containsKey('tanggal_dibuat') &&
          widget.filters['tanggal_dibuat']!.isNotEmpty) {
        try {
          DateTime kegiatanDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(aspirasi['tanggal_dibuat']);
          DateTime filterDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(widget.filters['tanggal_dibuat']!);

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
      totalAspirasi: filteredData.length,
    );
  }
}
