import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

// Card utama yang fleksibel untuk dashboard
class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// Widget untuk legenda di chart
class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;

  const LegendWidget({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Widget untuk Pie Chart dengan legenda
class PieChartWithLegend extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final List<Widget> legends;

  const PieChartWithLegend({
    super.key,
    required this.sections,
    required this.legends,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: legends,
        ),
      ],
    );
  }
}

// --- Halaman Utama Kependudukan ---
class Kependudukan extends StatelessWidget {
  const Kependudukan({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder untuk data email, sesuaikan dengan implementasi autentikasi

    return Scaffold(
      drawer: Sidebar(),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Kependudukan"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isNarrow = constraints.maxWidth < 800;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                // Top Info Cards
                _buildInfoCard(
                  icon: Icons.home_work_outlined,
                  title: 'Total Keluarga',
                  value: '9',
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                ),
                _buildInfoCard(
                  icon: Icons.groups_outlined,
                  title: 'Total Penduduk',
                  value: '11',
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                ),

                // Pie Chart Cards
                _buildPieChartCard(
                  icon: Icons.verified_user_outlined,
                  title: 'Status Penduduk',
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                  sections: [
                    _pieSection(82, '82%', Colors.teal),
                    _pieSection(18, '18%', Colors.brown.shade300),
                  ],
                  legends: [
                    const LegendWidget(color: Colors.teal, text: 'Aktif'),
                    LegendWidget(
                      color: Colors.brown.shade300,
                      text: 'Nonaktif',
                    ),
                  ],
                ),
                _buildPieChartCard(
                  icon: Icons.wc_outlined,
                  title: 'Jenis Kelamin',
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                  sections: [
                    _pieSection(91, '91%', Colors.blue),
                    _pieSection(9, '9%', Colors.redAccent),
                  ],
                  legends: [
                    const LegendWidget(color: Colors.blue, text: 'Laki-laki'),
                    const LegendWidget(
                      color: Colors.redAccent,
                      text: 'Perempuan',
                    ),
                  ],
                ),
                _buildPieChartCard(
                  icon: Icons.work_outline,
                  title: 'Pekerjaan Penduduk',
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                  sections: [
                    _pieSection(67, '67%', Colors.purple),
                    _pieSection(33, '33%', Colors.pink),
                  ],
                  legends: [
                    const LegendWidget(color: Colors.purple, text: 'Lainnya'),
                    const LegendWidget(color: Colors.pink, text: 'Pelajar'),
                  ],
                ),
                _buildPieChartCard(
                  icon: Icons.family_restroom_outlined,
                  title: 'Peran dalam Keluarga',
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                  sections: [
                    _pieSection(82, '82%', Colors.blue.shade700),
                    _pieSection(9, '9%', Colors.green),
                    _pieSection(
                      9,
                      '',
                      Colors.red.shade400,
                    ), // Anggota Lain tidak ada persen
                  ],
                  legends: [
                    LegendWidget(
                      color: Colors.blue.shade700,
                      text: 'Kepala Keluarga',
                    ),
                    const LegendWidget(color: Colors.green, text: 'Anak'),
                    LegendWidget(
                      color: Colors.red.shade400,
                      text: 'Anggota Lain',
                    ),
                  ],
                ),
                _buildPieChartCard(
                  icon: Icons.mosque_outlined,
                  title: 'Agama',
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                  sections: [
                    _pieSection(67, '67%', Colors.blue.shade600),
                    _pieSection(33, '33%', Colors.red.shade600),
                  ],
                  legends: [
                    LegendWidget(color: Colors.blue.shade600, text: 'Islam'),
                    LegendWidget(color: Colors.red.shade600, text: 'Katolik'),
                  ],
                ),
                _buildPieChartCard(
                  icon: Icons.school_outlined,
                  title: 'Pendidikan',
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                  sections: [_pieSection(100, '100%', Colors.grey.shade700)],
                  legends: [
                    LegendWidget(
                      color: Colors.grey.shade700,
                      text: 'Sarjana/Diploma',
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper untuk membuat PieChartSectionData dengan style yang konsisten
  PieChartSectionData _pieSection(double value, String title, Color color) {
    return PieChartSectionData(
      value: value,
      title: title,
      color: color,
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Helper untuk membangun kartu Pie Chart
  Widget _buildPieChartCard({
    required IconData icon,
    required String title,
    required double width,
    required List<PieChartSectionData> sections,
    required List<Widget> legends,
  }) {
    return SizedBox(
      width: width,
      child: StatCard(
        icon: icon,
        title: title,
        child: PieChartWithLegend(sections: sections, legends: legends),
      ),
    );
  }

  // Helper untuk membangun kartu Info (Total Keluarga & Penduduk)
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: StatCard(
        icon: icon,
        title: title,
        child: Text(
          value,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
