import 'package:flutter/material.dart';
import '../../../../data/warga_data.dart';
import 'tabel_header.dart';
import 'tabel_content.dart';
import 'tabel_pagination.dart';

class TabelWarga extends StatefulWidget {
  final Map<String, String> filters;

  const TabelWarga({super.key, required this.filters});

  @override
  State<TabelWarga> createState() => _TabelWargaState();
}

class _TabelWargaState extends State<TabelWarga> {
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void didUpdateWidget(TabelWarga oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filters != widget.filters) {
      setState(() {
        _currentPage = 1;
      });
    }
  }

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
          TabelHeader(totalWarga: filteredData.length),
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
    );
  }
}