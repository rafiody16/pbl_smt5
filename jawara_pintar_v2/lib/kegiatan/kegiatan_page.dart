import 'package:flutter/material.dart';
import '../../sidebar/sidebar.dart';
import 'components/tabel_kegiatan.dart';
import 'components/filter/filter_kegiatan.dart';

class KegiatanDaftarPage extends StatefulWidget {
  const KegiatanDaftarPage({super.key});

  @override
  State<KegiatanDaftarPage> createState() => _KegiatanDaftarPage();
}

class _KegiatanDaftarPage extends State<KegiatanDaftarPage> {
  final Map<String, String> _filters = {};
  final ScrollController _scrollController = ScrollController();

  void _onFilterApplied(Map<String, String> filters) {
    setState(() {
      _filters.clear();
      _filters.addAll(filters);
    });
  }

  void _onFilterReset() {
    setState(() {
      _filters.clear();
    });
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: FilterKegiatanDialog(
            onFilterApplied: _onFilterApplied,
            onFilterReset: _onFilterReset,
          ),
        );
      },
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          'Data Kegiatan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (_filters.isNotEmpty)
            Badge(
              backgroundColor: Colors.red,
              label: Text(_filters.length.toString()),
              offset: const Offset(-8, 8),
              child: IconButton(
                icon: const Icon(Icons.filter_alt_rounded),
                onPressed: () => _showFilterDialog(context),
                tooltip: 'Filter',
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () => _showFilterDialog(context),
              tooltip: 'Filter',
            ),
        ],
      ),
      drawer: const Sidebar(userEmail: 'admin@jawara.com'),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Column(
          children: [
            if (_filters.isNotEmpty) _buildActiveFilters(),

            // Content
            Expanded(
              child: KegiatanList(
                filters: _filters,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _filters.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _clearAllFilters,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.clear_all),
              label: const Text('Hapus Filter'),
              elevation: 2,
            )
          : null,
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.filter_alt,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              // const Text(
              const Flexible(
                child: Text(
                "Filter Aktif",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              )),
              const Spacer(),
              GestureDetector(
                onTap: _clearAllFilters,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.clear, size: 14, color: Colors.red[400]),
                      const SizedBox(width: 4),
                      Text(
                        "Hapus",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filters.entries.map((entry) {
              return Chip(
                label: Text(
                  "${entry.key}: ${entry.value}",
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue.withOpacity(0.1),
                deleteIcon: Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.blue[400],
                ),
                onDeleted: () {
                  setState(() {
                    _filters.remove(entry.key);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.blue.withOpacity(0.3)),
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
