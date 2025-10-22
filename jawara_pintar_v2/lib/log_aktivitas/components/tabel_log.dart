import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/log_data.dart';
import 'tabel_header.dart';
import 'tabel_content.dart';
import 'tabel_pagination.dart';

class TabelLog extends StatefulWidget {
  final Map<String, String> filters;

  const TabelLog({super.key, required this.filters});

  @override
  State<TabelLog> createState() => _TabelLogState();
}

class _TabelLogState extends State<TabelLog> {
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void didUpdateWidget(TabelLog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filters != widget.filters) {
      setState(() {
        _currentPage = 1;
      });
    }
  }

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

  List<Map<String, dynamic>> get _paginatedData {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= _filteredData.length) return [];

    return _filteredData.sublist(
      startIndex,
      endIndex.clamp(0, _filteredData.length),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _filteredData;
    final paginatedData = _paginatedData;
    final showPagination = filteredData.length > _itemsPerPage;

    return SizedBox.expand(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            TabelHeaderBroadcast(totalBroadcast: filteredData.length),
            const SizedBox(height: 16),
            Expanded(
              child: TabelContent(
                filteredData: paginatedData,
                currentPage: _currentPage,
                itemsPerPage: _itemsPerPage,
              ),
            ),
            if (showPagination) ...[
              const SizedBox(height: 16),
              TabelPagination(
                currentPage: _currentPage,
                totalItems: filteredData.length,
                itemsPerPage: _itemsPerPage,
                onPageChanged: _onPageChanged,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
