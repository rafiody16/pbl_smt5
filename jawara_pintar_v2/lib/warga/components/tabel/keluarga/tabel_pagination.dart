import 'package:flutter/material.dart';

class TabelPagination extends StatefulWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final Function(int) onPageChanged;

  const TabelPagination({
    super.key,
    this.currentPage = 1,
    this.totalItems = 0,
    this.itemsPerPage = 10,
    required this.onPageChanged,
  });

  @override
  State<TabelPagination> createState() => _TabelPaginationState();
}

class _TabelPaginationState extends State<TabelPagination> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
  }

  int get _totalPages => (widget.totalItems / widget.itemsPerPage).ceil();

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
      widget.onPageChanged(page);
    }
  }

  void _goToPreviousPage() {
    _goToPage(_currentPage - 1);
  }

  void _goToNextPage() {
    _goToPage(_currentPage + 1);
  }

  List<int> _getVisiblePages() {
    const int maxVisiblePages = 5;
    List<int> pages = [];

    if (_totalPages <= maxVisiblePages) {
      for (int i = 1; i <= _totalPages; i++) {
        pages.add(i);
      }
    } else {
      if (_currentPage <= 3) {
        pages = [1, 2, 3, 4];
        if (_totalPages > 4) pages.add(-1);
        pages.add(_totalPages);
      } else if (_currentPage >= _totalPages - 2) {
        pages = [1, -1];
        for (int i = _totalPages - 3; i <= _totalPages; i++) {
          pages.add(i);
        }
      } else {
        pages = [1, -1, _currentPage - 1, _currentPage, _currentPage + 1, -1, _totalPages];
      }
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.totalItems <= widget.itemsPerPage) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 20),
          onPressed: _currentPage > 1 ? _goToPreviousPage : null,
          color: _currentPage > 1 ? Colors.blue : Colors.grey,
        ),

        Row(
          children: _getVisiblePages().map((page) {
            if (page == -1) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "...",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            } else {
              final isCurrentPage = page == _currentPage;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  color: isCurrentPage ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => _goToPage(page),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        page.toString(),
                        style: TextStyle(
                          color: isCurrentPage ? Colors.white : Colors.grey[700],
                          fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }).toList(),
        ),

        IconButton(
          icon: const Icon(Icons.chevron_right, size: 20),
          onPressed: _currentPage < _totalPages ? _goToNextPage : null,
          color: _currentPage < _totalPages ? Colors.blue : Colors.grey,
        ),
      ],
    );
  }
}