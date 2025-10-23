import 'package:flutter/material.dart';
import 'filter_header.dart';
import 'filter_chips.dart';
import 'filter_buttons.dart';

class FilterWargaDialog extends StatefulWidget {
  final Function(Map<String, String>) onFilterApplied;
  final VoidCallback onFilterReset;

  const FilterWargaDialog({
    super.key,
    required this.onFilterApplied,
    required this.onFilterReset,
  });

  @override
  State<FilterWargaDialog> createState() => _FilterWargaDialogState();
}

class _FilterWargaDialogState extends State<FilterWargaDialog> {
  final Map<String, String> _selectedFilters = {};

  void _applyFilter() {
    widget.onFilterApplied(_selectedFilters);
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    setState(() {
      _selectedFilters.clear();
    });
    widget.onFilterReset();
  }

  void _onFilterSelected(String key, String value) {
    setState(() {
      if (_selectedFilters.containsKey(key) && _selectedFilters[key] == value) {
        _selectedFilters.remove(key);
      } else {
        _selectedFilters[key] = value;
      }
    });
  }

  bool _isFilterSelected(String key, String value) {
    return _selectedFilters.containsKey(key) && _selectedFilters[key] == value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FilterHeader(
            onClose: () => Navigator.of(context).pop(),
            selectedCount: _selectedFilters.length,
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilterChips(
                selectedFilters: _selectedFilters,
                onFilterSelected: _onFilterSelected,
                isFilterSelected: _isFilterSelected,
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: FilterButtons(
              onReset: _resetFilter,
              onApply: _applyFilter,
              selectedCount: _selectedFilters.length,
            ),
          ),
        ],
      ),
    );
  }
}