import 'package:flutter/material.dart';
import '../../../../../../data/warga_data.dart';

class FilterChips extends StatelessWidget {
  final Map<String, String> selectedFilters;
  final Function(String, String) onFilterSelected;
  final bool Function(String, String) isFilterSelected;

  const FilterChips({
    super.key,
    required this.selectedFilters,
    required this.onFilterSelected,
    required this.isFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Jenis Kelamin
        _buildFilterSection(
          title: "Jenis Kelamin",
          icon: Icons.person_outline,
          filters: WargaData.jenisKelaminList,
          filterKey: 'jenis_kelamin',
        ),
        
        const SizedBox(height: 24),
        
        // Filter Status Domisili
        _buildFilterSection(
          title: "Status Domisili",
          icon: Icons.home_work_outlined,
          filters: WargaData.statusDomisiliList,
          filterKey: 'status',
        ),
        
        const SizedBox(height: 24),
        
        // Filter Status Hidup
        _buildFilterSection(
          title: "Status Hidup",
          icon: Icons.favorite_border,
          filters: const ['Hidup', 'Meninggal'],
          filterKey: 'status_hidup',
        ),
        
        const SizedBox(height: 24),
        
        // Filter Keluarga
        _buildKeluargaSection(),
      ],
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required List<String> filters,
    required String filterKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filters.map((filter) {
            final isSelected = isFilterSelected(filterKey, filter);
            return FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => onFilterSelected(filterKey, filter),
              backgroundColor: Colors.grey[100],
              selectedColor: Colors.blue,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKeluargaSection() {
    final keluargaList = WargaData.dataKeluarga
        .map<String>((keluarga) => keluarga['nama_keluarga'] as String)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.group_outlined, color: Colors.blue, size: 18),
            const SizedBox(width: 8),
            const Text(
              "Keluarga",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: keluargaList.map((keluarga) {
            final isSelected = isFilterSelected('keluarga', keluarga);
            return FilterChip(
              label: Text(
                keluarga,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => onFilterSelected('keluarga', keluarga),
              backgroundColor: Colors.grey[100],
              selectedColor: Colors.green,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.green : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}