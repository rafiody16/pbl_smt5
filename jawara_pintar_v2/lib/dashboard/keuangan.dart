import 'package:flutter/material.dart';
import 'package:jawara_pintar_v2/sidebar/sidebar.dart';
import 'package:fl_chart/fl_chart.dart';

// Helper widget untuk membuat kartu informasi di bagian atas
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28),
          ),
        ],
      ),
    );
  }
}

// Helper widget untuk membungkus setiap chart
class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;

  const ChartCard({super.key, required this.title, required this.chart});

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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150, // Memberi tinggi tetap untuk chart
            child: chart,
          ),
        ],
      ),
    );
  }
}

// Helper widget untuk legenda di bawah pie chart
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
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

// --- Halaman Dashboard Utama ---
class DashboardPage extends StatelessWidget {
  // Konstruktor sekarang tidak memerlukan parameter userEmail
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Di sini kamu perlu mengambil data email dari state management atau cara lain
    // Untuk sementara, kita bisa gunakan nilai placeholder

    return Scaffold(
      // Sidebar tetap dipanggil dengan parameter email
      // drawer: const Sidebar(userEmail: currentUserEmail),
      drawer: Sidebar(),
      backgroundColor: const Color(0xfff0f4f7), // Warna background abu-abu muda
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Menambahkan tampilan tahun seperti di gambar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "2025",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Baris untuk 3 kartu info teratas
            LayoutBuilder(
              builder: (context, constraints) {
                // Menghitung lebar agar pas dan responsif
                double cardWidth = (constraints.maxWidth - 16) / 3;
                // Jika terlalu sempit, buat jadi 2 kolom
                // Jika layar dianggap sempit (kurang dari 500px), buat jadi 1 kolom
                if (constraints.maxWidth < 500) {
                  cardWidth =
                      constraints.maxWidth; // Lebar kartu = lebar layar penuh
                }
                // Jika tidak, buat jadi 3 kolom
                else {
                  // Lebar layar dikurangi total spasi (16px * 2 spasi), lalu dibagi 3
                  cardWidth = (constraints.maxWidth - 32) / 3;
                }

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: const InfoCard(
                        title: 'Total Pemasukan',
                        value: '50 jt',
                        icon: Icons.account_balance_wallet,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const InfoCard(
                        title: 'Total Pengeluaran',
                        value: '2.1 rb',
                        icon: Icons.shopping_cart,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const InfoCard(
                        title: 'Jumlah Transaksi',
                        value: '3',
                        icon: Icons.receipt_long,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Baris untuk 2 chart di tengah
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 16) / 2;
                // Jika layar terlalu sempit, buat chart jadi 1 kolom
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      ChartCard(
                        title: 'Pemasukan per Bulan',
                        chart: _buildPemasukanBarChart(),
                      ),
                      const SizedBox(height: 16),
                      ChartCard(
                        title: 'Pengeluaran per Bulan',
                        chart: _buildPengeluaranBarChart(),
                      ),
                    ],
                  );
                }
                // Jika layar lebar, buat 2 kolom
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: ChartCard(
                        title: 'Pemasukan per Bulan',
                        chart: _buildPemasukanBarChart(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: cardWidth,
                      child: ChartCard(
                        title: 'Pengeluaran per Bulan',
                        chart: _buildPengeluaranBarChart(),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Baris untuk 2 pie chart di bawah
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 16) / 2;
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      ChartCard(
                        title: 'Pemasukan Berdasarkan Kategori',
                        chart: _buildPieChart(
                          color: Colors.redAccent,
                          label: 'Pendapatan Lainnya',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ChartCard(
                        title: 'Pengeluaran Berdasarkan Kategori',
                        chart: _buildPieChart(
                          color: Colors.redAccent,
                          label: 'Pemeliharaan Fasilitas',
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: ChartCard(
                        title: 'Pemasukan Berdasarkan Kategori',
                        chart: _buildPieChart(
                          color: Colors.redAccent,
                          label: 'Pendapatan Lainnya',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: cardWidth,
                      child: ChartCard(
                        title: 'Pengeluaran Berdasarkan Kategori',
                        chart: _buildPieChart(
                          color: Colors.redAccent,
                          label: 'Pemeliharaan Fasilitas',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget untuk membuat chart ---

  Widget _buildPemasukanBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 60, // Nilai maksimal Y axis
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
                const style = TextStyle(fontSize: 12);
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = 'Agu';
                    break;
                  case 1:
                    text = 'Okt';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(text, style: style),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value % 15 == 0) {
                  return Text(
                    '${value.toInt()} jt',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
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
          // Data untuk bulan Agustus (nilai 0)
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: 0, color: Colors.blueAccent, width: 20),
            ],
          ),
          // Data untuk bulan Oktober
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 50,
                color: Colors.blueAccent,
                width: 20,
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

  Widget _buildPengeluaranBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: 2.2, // Dalam satuan 'rb'
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
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text('Okt', style: TextStyle(fontSize: 12)),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '${value.toStringAsFixed(1)} rb',
                  style: const TextStyle(fontSize: 10),
                );
              },
              interval: 0.55,
              reservedSize: 40,
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
          // Data untuk bulan Oktober
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 2.1,
                color: Colors.redAccent,
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

  Widget _buildPieChart({required Color color, required String label}) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: [
                // Ini adalah data untuk 100% kategori
                PieChartSectionData(
                  color: color,
                  value: 100,
                  title: '100%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Bagian 0% tidak perlu digambar, tapi jika ingin ada garis
                // bisa ditambahkan section dengan value sangat kecil.
                // Untuk kesederhanaan, kita hanya gambar yang 100%.
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        LegendWidget(color: color, text: label),
      ],
    );
  }
}
