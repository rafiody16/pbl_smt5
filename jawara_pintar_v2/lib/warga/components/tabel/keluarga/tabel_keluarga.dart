import 'package:flutter/material.dart';
import '../../../../data/warga_data.dart';
import 'tabel_header.dart';
import 'tabel_content.dart';
import 'tabel_pagination.dart';

class TabelKeluarga extends StatefulWidget {
  final Map<String, String> filters;

  const TabelKeluarga({super.key, required this.filters});

  @override
  State<TabelKeluarga> createState() => _TabelKeluargaState();
}

class _TabelKeluargaState extends State<TabelKeluarga> {
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  List<Map<String, dynamic>> get _filteredData {
    if (widget.filters.isEmpty) return WargaData.dataKeluarga;

    return WargaData.dataKeluarga.where((keluarga) {
      if (widget.filters.containsKey('nama') &&
          !keluarga['nama_keluarga'].toString().toLowerCase().contains(widget.filters['nama']!.toLowerCase()) &&
          !keluarga['kepala_keluarga'].toString().toLowerCase().contains(widget.filters['nama']!.toLowerCase())) {
        return false;
      }

      if (widget.filters.containsKey('status') &&
          keluarga['status'] != widget.filters['status']) {
        return false;
      }

      if (widget.filters.containsKey('rumah') &&
          keluarga['status_kepemilikan'] != widget.filters['rumah']) {
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
    final showPagination = _filteredData.length > _itemsPerPage;

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
          TabelHeader(totalKeluarga: _filteredData.length),
          const SizedBox(height: 16),
          TabelContent(filteredData: _paginatedData),
          if (showPagination) ...[
            const SizedBox(height: 16),
            TabelPagination(
              currentPage: _currentPage,
              totalItems: _filteredData.length,
              itemsPerPage: _itemsPerPage,
              onPageChanged: _onPageChanged,
            ),
          ],
        ],
      ),
    );
  }
}