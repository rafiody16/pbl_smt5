import 'package:flutter/material.dart';
import '../warga/pages/warga_daftar_page.dart';
import '../login/login_page.dart';

class Sidebar extends StatelessWidget {
  final String userEmail;

  const Sidebar({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 80, 
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Jawara Pintar",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          _buildMenuSection("Dashboard", Icons.dashboard, [
            _buildSubMenu(context, "Keuangan"),
            _buildSubMenu(context, "Kegiatan"),
            _buildSubMenu(context, "Kependudukan"),
          ]),

          _buildMenuSection("Data Warga & Rumah", Icons.people, [
            _buildSubMenu(context, "Warga - Daftar", onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WargaDaftarPage()),
              );
            }),
            _buildSubMenu(context, "Warga - Tambah"),
            _buildSubMenu(context, "Keluarga"),
            _buildSubMenu(context, "Rumah - Daftar"),
            _buildSubMenu(context, "Rumah - Tambah"),
          ]),

          _buildMenuSection("Pemasukan", Icons.trending_up, [
            _buildSubMenu(context, "Kategori Iuran"),
            _buildSubMenu(context, "Tagih Iuran"),
            _buildSubMenu(context, "Tagihan"),
            _buildSubMenu(context, "Pemasukan Lain - Daftar"),
            _buildSubMenu(context, "Pemasukan Lain - Tambah"),
          ]),

          Container(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 20,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Log out",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            title: const Text("Admin Jawara"),
            subtitle: Text(userEmail),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, IconData icon, List<Widget> subItems) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: subItems,
    );
  }

  Widget _buildSubMenu(BuildContext context, String title, {VoidCallback? onTap}) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      onTap: onTap,
    );
  }
}