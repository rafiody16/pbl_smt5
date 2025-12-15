import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';

// Card utama yang lebih fleksibel untuk dashboard kegiatan
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

// Widget untuk legenda di chart kategori
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

// --- Halaman Utama Kegiatan ---
class Kegiatan extends StatelessWidget {
  // Konstruktor sekarang tidak memerlukan parameter userEmail
  const Kegiatan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      backgroundColor: const Color(0xfff0f4f7),
      appBar: AppBar(
        title: const Text("Kegiatan"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isNarrow = constraints.maxWidth < 700;
            double cardWidth = isNarrow
                ? constraints.maxWidth
                : (constraints.maxWidth - 16) / 2;

            return Column(
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    // Card: Total Kegiatan
                    SizedBox(
                      width: cardWidth,
                      child: DashboardCard(
                        icon: Icons.emoji_events_outlined,
                        title: 'Total Kegiatan',
                        color: Colors.blue.shade700,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 48,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text('Jumlah seluruh event yang sudah ada'),
                          ],
                        ),
                      ),
                    ),

                    // Card: Kegiatan per Kategori
                    SizedBox(
                      width: cardWidth,
                      child: DashboardCard(
                        icon: Icons.pie_chart_outline_rounded,
                        title: 'Kegiatan per Kategori',
                        color: Colors.green.shade700,
                        child: _buildCategorySection(),
                      ),
                    ),

                    // Card: Kegiatan berdasarkan Waktu
                    SizedBox(
                      width: cardWidth,
                      child: DashboardCard(
                        icon: Icons.access_time_rounded,
                        title: 'Kegiatan berdasarkan Waktu',
                        color: Colors.orange.shade800,
                        child: Column(
                          children: [
                            _buildTimeInfoRow('Sudah Lewat', '1'),
                            _buildTimeInfoRow('Hari Ini', '0'),
                            _buildTimeInfoRow('Akan Datang', '0'),
                          ],
                        ),
                      ),
                    ),

                    // Card: Penanggung Jawab Terbanyak
                    SizedBox(
                      width: cardWidth,
                      child: DashboardCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Penanggung Jawab Terbanyak',
                        color: Colors.purple.shade700,
                        child: _buildTimeInfoRow('Pak', '1'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Card Barchart full-width
                DashboardCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Kegiatan per Bulan (Tahun Ini)',
                  color: Colors.pink.shade600,
                  child: SizedBox(height: 200, child: _buildActivityBarChart()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper untuk baris info di card "berdasarkan waktu" & "penanggung jawab"
  Widget _buildTimeInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- Widget untuk membuat chart ---

  Widget _buildCategorySection() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: Colors.blue,
                  value: 100,
                  title: '100%',
                  radius: 30,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.grey.shade300,
                  value: 0, // Placeholder for 0%
                  title: '0%',
                  radius: 30,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            LegendWidget(color: Colors.blue, text: 'Komunitas & Sosial'),
            LegendWidget(color: Colors.green, text: 'Kebersihan & Keamanan'),
            LegendWidget(color: Colors.orange, text: 'Keagamaan'),
            LegendWidget(color: Colors.purple, text: 'Pendidikan'),
            LegendWidget(color: Colors.red, text: 'Kesehatan & Olahraga'),
            LegendWidget(color: Colors.grey, text: 'Lainnya'),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() == 0) {
                  return const Text('Okt', style: TextStyle(fontSize: 12));
                }
                return const Text('');
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.25,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 10),
                );
              },
              reservedSize: 32,
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 1,
                color: Colors.pink.shade400,
                width: 30,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
