import 'package:flutter/material.dart';
import '../../../../data/log_data.dart';
import 'tabel_content.dart';
import 'package:intl/intl.dart';

class LogList extends StatefulWidget {
  final Map<String, String> filters;
  final ScrollController scrollController;

  const LogList({
    super.key,
    required this.filters,
    required this.scrollController,
  });

  @override
  State<LogList> createState() => _LogListState();
}

class _LogListState extends State<LogList> {
  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allLog = LogData.semuaDataLog;

    if (widget.filters.isEmpty) return allLog;

    return allLog.where((log) {
      if (widget.filters.containsKey('aktor') &&
          widget.filters['aktor']!.isNotEmpty &&
          !log['aktor'].toString().toLowerCase().contains(
            widget.filters['aktor']!.toLowerCase(),
          )) {
        return false;
      }

      if (widget.filters.containsKey('deskripsi') &&
          widget.filters['deskripsi']!.isNotEmpty &&
          log['deskripsi'] != widget.filters['deskripsi']) {
        return false;
      }

      if (widget.filters.containsKey('tanggal') &&
          widget.filters['tanggal']!.isNotEmpty) {
        try {
          DateTime kegiatanDate = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).parse(log['tanggal']);
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
      totalLog: filteredData.length,
    );
  }
}
