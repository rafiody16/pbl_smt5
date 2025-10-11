import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: const [
          DashboardMenu(
            icon: Icons.school,
            label: "Kelas",
            color: Colors.orange,
          ),
          DashboardMenu(
            icon: Icons.assignment,
            label: "Tugas",
            color: Colors.green,
          ),
          DashboardMenu(
            icon: Icons.bar_chart,
            label: "Nilai",
            color: Colors.blue,
          ),
          DashboardMenu(
            icon: Icons.person,
            label: "Profil",
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class DashboardMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const DashboardMenu({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Membuka $label...')),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
