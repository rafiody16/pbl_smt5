import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_pintar_v2/manajemen_pengguna/halaman_daftar_pengguna.dart';
import 'package:jawara_pintar_v2/manajemen_pengguna/halaman_tambah_pengguna.dart';
import 'package:jawara_pintar_v2/mutasi_keluarga/halaman_tambah_mutasi.dart';
import 'package:jawara_pintar_v2/views/keluarga/keluarga_stream_page.dart';
import 'package:jawara_pintar_v2/views/rumah/rumah_stream_page.dart';
import 'package:jawara_pintar_v2/dashboard/kependudukan.dart';
import 'package:jawara_pintar_v2/keuangan/laporan.dart';
import 'package:jawara_pintar_v2/keuangan/pemasukan.dart';
import 'package:jawara_pintar_v2/keuangan/pengeluaran.dart';
import '../../kegiatan/kegiatan_page.dart';
import '../../marketplace/pages/produk_form_page.dart';
import '../../mutasi_keluarga/halaman_daftar_mutasi.dart';
import '../../mutasi_keluarga/halaman_tambah_mutasi.dart';
import '../../kegiatan/kegiatan_tambah_page.dart';
import '../../broadcast/broadcast_daftar_page.dart';
import '../../broadcast/broadcast_tambah_page.dart';
import '../../log_aktivitas/log_aktivitas_page.dart';
import '../../pesan_warga/pesan_warga_page.dart';
import '../../penerimaanWarga/pages/penerimaan_warga_page.dart';
import '../../dashboard/keuangan.dart';
import '../../dashboard/kegiatan.dart';
import '../../pemasukan/kategori_iuran.dart';
import '../../pemasukan/tagih_iuran.dart';
import '../../pemasukan/tagihan.dart';
import '../../pemasukan/pemasukan_lain_daftar.dart';
import '../../pemasukan/pemasukan_lain_tambah.dart';
import '../../pengeluaran/daftar.dart';
import '../../pengeluaran/tambah.dart';
import '../../chanel_tranfer/halaman_daftar_chanel.dart';
import '../../chanel_tranfer/halaman_tambah_chanel.dart';
import '../../views/warga/pages/warga_list_page.dart';
import '../../views/pengguna/pages/pengguna_list_page.dart';
import '../../marketplace/pages/marketplace_list.dart';

class SidebarMenu extends StatelessWidget {
  final String? userRole;
  SidebarMenu({super.key, this.userRole});

  bool _hasAccess(List<String> allowedRoles) {
    if (userRole == null) return false;
    return allowedRoles.contains(userRole);
  }

  // Role access untuk setiap menu section
  final Map<String, List<String>> sectionAccess = {
    'Dashboard': [
      'admin',
      'bendahara',
      'sekretaris',
      'ketua_rt',
      'ketua_rw',
      'warga',
    ],
    'Data Warga & Rumah': [
      'admin',
      'sekretaris',
      'ketua_rt',
      'ketua_rw',
      'warga',
    ],
    'Pemasukan': ['bendahara', 'admin'],
    'Pengeluaran': ['bendahara', 'admin'],
    'Laporan Keuangan': ['bendahara', 'admin', 'ketua_rt', 'ketua_rw'],
    'Kegiatan & Broadcast': [
      'admin',
      'sekretaris',
      'ketua_rt',
      'ketua_rw',
      'warga',
    ],
    'Pesan Warga': ['admin', 'ketua_rt', 'ketua_rw', 'warga'],
    'Marketplace': [
      'warga',
      'admin',
      'sekretaris',
      'ketua_rt',
      'ketua_rw',
      'bendahara',
    ],
    'Data Pengguna': ['admin', 'sekretaris', 'ketua_rt', 'ketua_rw'],
    'Mutasi Keluarga': ['admin', 'sekretaris', 'ketua_rt', 'ketua_rw'],
    'Log Aktivitas': ['admin'],
    'Channel Transfer': ['bendahara', 'admin'],
  };

  final List<MenuSection> menuSections = [
    MenuSection(
      title: "Dashboard",
      icon: Icons.dashboard,
      subMenus: [
        SubMenu(
          "Keuangan",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          },
        ),
        SubMenu(
          "Kegiatan",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Kegiatan()),
            );
          },
        ),
        SubMenu(
          "Kependudukan",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Kependudukan()),
            );
          },
        ),
      ],
    ),

    MenuSection(
      title: "Data Warga & Rumah",
      icon: Icons.home_work_sharp,
      subMenus: [
        SubMenu(
          "Warga",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WargaListPage()),
            );
          },
        ),
        SubMenu(
          "Keluarga",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const KeluargaStreamPage(),
              ),
            );
          },
        ),
        SubMenu(
          "Rumah",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RumahStreamPage()),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Pemasukan",
      icon: Icons.trending_up,
      subMenus: [
        SubMenu(
          "Kategori Iuran",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const KategoriIuranPage(),
              ),
            );
          },
        ),
        SubMenu(
          "Tagih Iuran",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TagihIuranPage()),
            );
          },
        ),
        SubMenu(
          "Tagihan",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TagihanPage()),
            );
          },
        ),
        SubMenu(
          "Pemasukan Lain - Daftar",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PemasukanLainDaftar(),
              ),
            );
          },
        ),
        SubMenu(
          "Pemasukan Lain - Tambah",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PemasukanLainTambah(),
              ),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Pengeluaran",
      icon: Icons.trending_down,
      subMenus: [
        SubMenu(
          "Daftar",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PengeluaranDaftarPage(),
              ),
            );
          },
        ),
        SubMenu(
          "Tambah",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PengeluaranTambahPage(),
              ),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Laporan Keuangan",
      icon: Icons.receipt_long,
      subMenus: [
        SubMenu(
          "Semua Pemasukan",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Pemasukan()),
            );
          },
        ),
        SubMenu(
          "Semua Pengeluaran",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Pengeluaran()),
            );
          },
        ),
        SubMenu(
          "Cetak Laporan",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Laporan()),
            );
          },
        ),
      ],
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
              MaterialPageRoute(
                builder: (context) => const KegiatanDaftarPage(),
              ),
            );
          },
        ),
        SubMenu(
          "Kegiatan - Tambah",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const KegiatanTambahPage(),
              ),
            );
          },
        ),
        SubMenu(
          "Broadcast - Daftar",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BroadcastDaftarPage(),
              ),
            );
          },
        ),
        SubMenu(
          "Broadcast - Tambah",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BroadcastTambahPage(),
              ),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Pesan Warga",
      icon: Icons.message,
      subMenus: [
        SubMenu(
          "Informasi Aspirasi",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AspirasiDaftarPage(),
              ),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Marketplace",
      icon: Icons.storefront,
      subMenus: [
        SubMenu(
          "Marketplace",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MarketplaceListPage(),
              ),
            );
          },
        ),
        SubMenu(
          "Produk",
          // onTap: (context) {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => const ProdukListPage()),
          //   );
          // },
        ),
        SubMenu(
          "Tambah Produk",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProdukFormPage()),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Data Pengguna",
      icon: Icons.group,
      subMenus: [
        SubMenu(
          "Manajemen Pengguna",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PenggunaListPage()),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Mutasi Keluarga",
      icon: Icons.family_restroom,
      subMenus: [
        SubMenu(
          "Daftar",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MutasiDaftarScreen(),
              ),
            );
          },
        ),

        SubMenu(
          "Tambah",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MutasiTambahScreen(),
              ),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Log Aktivitas",
      icon: Icons.history,
      subMenus: [
        SubMenu(
          "Semua Aktivitas",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LogDaftarPage()),
            );
          },
        ),
      ],
    ),
    MenuSection(
      title: "Channel Transfer",
      icon: Icons.swap_horiz,
      subMenus: [
        SubMenu(
          "Daftar Channel",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HalamanDaftarChanel(),
              ),
            );
          },
        ),
        SubMenu(
          "Tambah Channel",
          onTap: (context) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChanelTambahScreen(),
              ),
            );
          },
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        for (var section in menuSections)
          if (_hasAccess(sectionAccess[section.title] ?? []))
            _buildMenuSection(context, section),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, MenuSection section) {
    // Definisikan access control per submenu jika perlu
    final subMenuAccess = {
      'Warga - Tambah': ['admin', 'sekretaris'],
      'Kategori Iuran': ['bendahara', 'admin'],
      'Tagih Iuran': ['bendahara', 'admin'],
      'Daftar': ['bendahara', 'admin'], // untuk pengeluaran
      'Tambah': ['bendahara', 'admin'], // untuk pengeluaran
    };

    return ExpansionTile(
      leading: Icon(section.icon, color: Colors.black87),
      title: Text(
        section.title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      children: section.subMenus
          .where((subMenu) {
            if (subMenu is SubMenu) {
              // Return true jika user punya akses atau tidak ada restriction
              return _hasAccess(
                subMenuAccess[subMenu.title] ?? [userRole ?? ''],
              );
            }
            return true;
          })
          .map((subMenu) {
            if (subMenu is SubMenu) {
              return _buildSubMenu(
                context,
                subMenu.title,
                onTap: subMenu.onTap,
              );
            } else {
              return _buildSubMenu(context, subMenu.toString());
            }
          })
          .toList(),
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
