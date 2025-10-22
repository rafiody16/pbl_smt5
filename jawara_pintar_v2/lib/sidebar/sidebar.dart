import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login/login_page.dart';
import 'components/sidebar_header.dart';
import 'components/sidebar_menu.dart';
import 'components/sidebar_footer.dart';

class Sidebar extends StatefulWidget {
  final String userEmail;

  const Sidebar({super.key, required this.userEmail});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: Stack(
        children: [
          Column(
            children: [
              const SidebarHeader(),
              
              // menu items
              Expanded(
                child: SidebarMenu(),
              ),

              // footer
              SidebarFooter(
                userEmail: widget.userEmail,
                isExpanded: _isExpanded,
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ],
          ),

          // overlay logout
          if (_isExpanded)
            Positioned(
              bottom: 70,
              left: 8,
              right: 8,
              child: _buildLogoutOverlay(),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Admin Jawara",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.userEmail,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

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
            _buildSubMenu(
              context, 
              "Daftar Pengguna", 
              onTap: () {
                print("wokay");
                Navigator.pushReplacementNamed(context, '/daftarPengguna');
              },
              isActive: true,
            ),

          ]),

          const SizedBox(height: 20),

          const Divider(),

          // Footer
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
              ),
            ),
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

   Widget _buildSubMenu(BuildContext context, String title, {VoidCallback? onTap, bool isActive = false}) {
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
      onTap: () {
        print("wwcwce");
        // 1. Selalu tutup sidebar saat item menu diklik
        Navigator.pop(context);
        // 2. Jalankan aksi onTap yang diberikan (navigasi, dll)
        onTap?.call();
      },
    );
  }
}
