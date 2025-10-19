import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../warga/pages/warga_daftar_page.dart';
import '../../kegiatan/kegiatan_page.dart';
import '../../warga/pages/warga_tambah_page.dart';
import '../../warga/pages/keluarga.dart';
import '../../warga/pages/rumah_daftar_page.dart';
import '../../warga/pages/rumah_tambah_page.dart';
import '../../penerimaanWarga/pages/penerimaan_warga_page.dart';

class SidebarMenu extends StatelessWidget {
  SidebarMenu({super.key});

  final List<MenuSection> menuSections = [
    MenuSection(
      title: "Dashboard",
      icon: Icons.dashboard,
      subMenus: ["Keuangan", "Kegiatan", "Kependudukan"],
    ),
    MenuSection(
      title: "Data Warga & Rumah",
      icon: Icons.people,
      subMenus: [
        SubMenu(
          "Warga - Daftar",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WargaDaftarPage()),
            );
          },
        ),
        SubMenu(
          "Warga - Tambah",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WargaTambahPage()),
            );
          },
        ),
        SubMenu(
          "Keluarga",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const KeluargaDaftarPage(),
              ),
            );
          },
        ),
        SubMenu(
          "Rumah - Daftar",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RumahDaftarPage()),
            );
          },
        ),
        SubMenu(
          "Rumah - Tambah",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RumahTambahPage()),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Pemasukan",
      icon: Icons.trending_up,
      subMenus: [
        "Kategori Iuran",
        "Tagih Iuran",
        "Tagihan",
        "Pemasukan Lain - Daftar",
        "Pemasukan Lain - Tambah",
      ],
    ),
    MenuSection(
      title: "Pengeluaran",
      icon: Icons.trending_down,
      subMenus: ["Daftar", "Tambah"],
    ),
    MenuSection(
      title: "Laporan Keuangan",
      icon: Icons.receipt_long,
      subMenus: ["Semua Pemasukan", "Semua Pengeluaran", "Cetak Laporan"],
    ),
    MenuSection(
      title: "Kegiatan & Broadcast",
      icon: Icons.campaign,
      subMenus: [
        SubMenu(
          "Kegiatan - Daftar",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const KegiatanPage()),
            );
          },
        ),
        SubMenu("Kegiatan - Tambah"),
        SubMenu("Broadcast - Daftar"),
        SubMenu("Broadcast - Tambah"),
      ],
    ),
    MenuSection(
      title: "Pesan Warga",
      icon: Icons.message,
      subMenus: ["Informasi Aspirasi"],
    ),
    MenuSection(
      title: "Penerimaan Warga",
      icon: Icons.person_add,
      subMenus: [
        SubMenu(
          "Penerimaan Warga",
          onTap: (context) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder:  (context) => const PenerimaanWargaPage()),
              );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Mutasi Keluarga",
      icon: Icons.group,
      subMenus: ["Daftar", "Tambah"],
    ),
    MenuSection(
      title: "Log Aktivitas",
      icon: Icons.history,
      subMenus: ["Semua Aktifitas"],
    ),
    MenuSection(
      title: "Manajemen Pengguna",
      icon: Icons.settings,
      subMenus: [
        SubMenu(
          "Daftar Pengguna",
          onTap: (context) {
            Navigator.pushReplacementNamed(context, '/daftarPengguna');
          },
        ),
        SubMenu("Tambah Pengguna"),
      ],
    ),
    MenuSection(
      title: "Channel Transfer",
      icon: Icons.swap_horiz,
      subMenus: ["Daftar Channel", "Tambah Channel"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        for (var section in menuSections) _buildMenuSection(context, section),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, MenuSection section) {
    return ExpansionTile(
      leading: Icon(section.icon, color: Colors.black87),
      title: Text(
        section.title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      children: section.subMenus.map((subMenu) {
        if (subMenu is SubMenu) {
          return _buildSubMenu(context, subMenu.title, onTap: subMenu.onTap);
        } else {
          return _buildSubMenu(context, subMenu.toString());
        }
      }).toList(),
    );
  }

  Widget _buildSubMenu(
    BuildContext context,
    String title, {
    Function(BuildContext)? onTap,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(title, style: GoogleFonts.poppins(fontSize: 13)),
      ),
      onTap: onTap != null
          ? () {
              Navigator.pop(context);
              onTap(context);
            }
          : null,
    );
  }
}

class MenuSection {
  final String title;
  final IconData icon;
  final List<dynamic> subMenus;

  MenuSection({
    required this.title,
    required this.icon,
    required this.subMenus,
  });
}

class SubMenu {
  final String title;
  final Function(BuildContext)? onTap;

  SubMenu(this.title, {this.onTap});

  @override
  String toString() => title;
}
