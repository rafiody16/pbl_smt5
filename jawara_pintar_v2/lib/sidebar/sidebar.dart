import 'package:flutter/material.dart';

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
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4), 
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Jawara Pintar.",
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
            _buildSubMenu(context, "Warga - Daftar"),
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

          _buildMenuSection("Pengeluaran", Icons.trending_down, [
            _buildSubMenu(context, "Daftar"),
            _buildSubMenu(context, "Tambah"),
          ]),

          _buildMenuSection("Laporan Keuangan", Icons.receipt_long, [
            _buildSubMenu(context, "Semua Pemasukan"),
            _buildSubMenu(context, "Semua Pengeluaran"),
            _buildSubMenu(context, "Cetak Laporan"),
          ]),
          
          _buildMenuSection("Kegiatan & Broadcast", Icons.campaign, [
            _buildSubMenu(context, "Kegiatan - Daftar"),
            _buildSubMenu(context, "Kegiatan - Tambah"),
            _buildSubMenu(context, "Broadcast - Daftar"),
            _buildSubMenu(context, "Broadcast - Tambah"),
          ]),

          _buildMenuSection("Pesan Warga", Icons.message, [
            _buildSubMenu(context, "Informasi Aspirasi"),
          ]),

          _buildMenuSection("Penerimaan Warga", Icons.person_add, [
            _buildSubMenu(context, "Penerimaan Warga"),
          ]),

          _buildMenuSection("Mutasi Keluarga", Icons.group, [
            _buildSubMenu(context, "Daftar"),
            _buildSubMenu(context, "Tambah"),
          ]),

          _buildMenuSection("Log Aktivitas", Icons.history, [
            _buildSubMenu(context, "Semua Aktifitas"),
          ]),

          _buildMenuSection("Manajemen Pengguna", Icons.settings, [
            _buildSubMenu(context, "Daftar Pengguna"),
            _buildSubMenu(context, "Tambah Pengguna"),
          ]),

          _buildMenuSection("Channel Transfer", Icons.swap_horiz, [
            _buildSubMenu(context, "Daftar Channel"),
            _buildSubMenu(context, "Tambah Channel"),
          ]),

          const SizedBox(height: 20),

          const Divider(),

          // Footer
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: const Text("Admin Jawara"),
            subtitle: Text (userEmail),
            onTap: () {},
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

  Widget _buildSubMenu(BuildContext context, String title,
      {bool isActive = false}) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
