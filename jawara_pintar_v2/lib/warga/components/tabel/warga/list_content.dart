import 'package:flutter/material.dart';
import '../../shared/status_chip.dart';
import '../../../../data/warga_data.dart';
import '../../detail/warga_detail_page.dart';

class ListContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredData;
  final ScrollController scrollController;
  final int totalWarga;

  const ListContent({
    super.key,
    required this.filteredData,
    required this.scrollController,
    required this.totalWarga,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredData.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filteredData.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final warga = filteredData[index];
        return _buildWargaCard(warga, index + 1, context);
      },
    );
  }

  Widget _buildWargaCard(Map<String, dynamic> warga, int nomorUrut, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showDetail(warga, context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nomor urut
                // Container(
                //   width: 32,
                //   height: 32,
                //   decoration: BoxDecoration(
                //     color: Colors.blue.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Center(
                //     child: Text(
                //       nomorUrut.toString(),
                //       style: const TextStyle(
                //         fontWeight: FontWeight.bold,
                //         color: Colors.blue,
                //         fontSize: 12,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        warga['nama'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        warga['nik'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoChip(
                              _getKeluargaName(warga),
                              Icons.group,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          
                          _buildInfoChip(
                            warga['jenis_kelamin'],
                            Icons.person,
                            Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      Row(
                        children: [
                          StatusChip(status: warga['status_domisili'], compact: true),
                          const SizedBox(width: 6),
                          StatusChip(status: warga['status_hidup'], compact: true),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
        ],
      ),
    );
  }

  String _getKeluargaName(Map<String, dynamic> warga) {
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
    return '-';
  }

  void _showDetail(Map<String, dynamic> warga, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WargaDetailPage(warga: warga),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Tidak ada data ditemukan",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Coba ubah filter pencarian Anda",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}