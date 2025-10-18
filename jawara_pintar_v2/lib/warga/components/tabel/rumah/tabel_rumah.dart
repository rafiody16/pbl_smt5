import 'package:flutter/material.dart';
import '../../../../data/rumah_data.dart';
import 'tabel_header.dart';
import 'tabel_content.dart';
import 'tabel_pagination.dart';

class TabelRumah extends StatefulWidget {
  final Map<String, String> filters;

  const TabelRumah({super.key, required this.filters});

  @override
  State<TabelRumah> createState() => _TabelRumahState();
}

class _TabelRumahState extends State<TabelRumah> {
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void didUpdateWidget(TabelRumah oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filters != widget.filters) {
      setState(() {
        _currentPage = 1;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allRumah = RumahData.semuaDataRumah;

    if (widget.filters.isEmpty) return allRumah;

    return allRumah.where((rumah) {
      if (widget.filters.containsKey('alamat') &&
          widget.filters['alamat']!.isNotEmpty &&
          !rumah['alamat'].toString().toLowerCase().contains(widget.filters['alamat']!.toLowerCase())) {
        return false;
      }
      if (widget.filters.containsKey('status') &&
          widget.filters['status']!.isNotEmpty &&
          rumah['status'] != widget.filters['status']) {
        return false;
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedData {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    
    if (startIndex >= _filteredData.length) {
      return [];
    }
    
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

    return Container(
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
          TabelHeaderRumah(totalRumah: filteredData.length),
          const SizedBox(height: 16),
          Expanded(
            child: TabelContentRumah(
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
    );
  }
}