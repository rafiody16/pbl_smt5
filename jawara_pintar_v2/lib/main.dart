import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// === IMPORT PROVIDERS ===
import 'providers/auth_provider.dart';
import 'providers/warga_provider.dart';
import 'providers/keuangan_provider.dart';
import 'providers/produk_provider.dart'; // PENTING: Tambahkan ini

// === IMPORT HALAMAN ===
import 'login/login_page.dart';
import 'register/register_page.dart';
import 'manajemen_pengguna/halaman_daftar_pengguna.dart';
import 'kegiatan/kegiatan_page.dart';
import 'kegiatan/kegiatan_tambah_page.dart';
import 'broadcast/broadcast_daftar_page.dart';
import 'broadcast/broadcast_tambah_page.dart';
import 'log_aktivitas/log_aktivitas_page.dart';
import 'pesan_warga/pesan_warga_page.dart';
import 'dashboard/keuangan.dart';
import 'penerimaanWarga/pages/penerimaan_warga_page.dart';

// Import Warga (New Structure)
import 'views/warga/pages/warga_list_page.dart';
import 'views/warga/pages/warga_form_page.dart';
import 'views/warga/pages/warga_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://oacynurgiosfrdujfnxz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hY3ludXJnaW9zZnJkdWpmbnh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2MzEwMDcsImV4cCI6MjA4MDIwNzAwN30.I3sA09SjQftcb0OJ-GS3Qet9nb_wSc3XtqrnNNiMvLM',
  );

  // Inisialisasi format tanggal (Indonesia)
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // === DAFTAR PROVIDER DISINI ===
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WargaProvider()),
        ChangeNotifierProvider(create: (_) => ProdukProvider()),

        // PENTING: Provider Keuangan ditambahkan disini agar bisa diakses seluruh aplikasi
        // '..initData()' digunakan agar data langsung diambil saat aplikasi dibuka
        ChangeNotifierProvider(create: (_) => KeuanganProvider()..initData()),
      ],
      child: MaterialApp(
        title: 'Jawara Pintar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primarySwatch: Colors.blue,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFF),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),

        // Halaman awal
        home: const LoginPage(),

        // Daftar Routes
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/daftarPengguna': (context) => const UserListScreen(),
          '/dashboard': (context) => const DashboardPage(),
          '/kegiatan': (context) => const KegiatanDaftarPage(),
          '/kegiatan/tambah': (context) => const KegiatanTambahPage(),
          '/broadcast': (context) => const BroadcastDaftarPage(),
          '/broadcast/tambah': (context) => const BroadcastTambahPage(),
          '/log': (context) => const LogDaftarPage(),
          '/aspirasi': (context) => const AspirasiDaftarPage(),

          // Routes Warga (New)
          '/warga/list': (context) => const WargaListPage(),
          '/warga/add': (context) => const WargaFormPage(),
          '/warga/edit': (context) => const WargaFormPage(isEdit: true),
          '/warga/detail': (context) => const WargaDetailPage(),

          // Routes Lainnya
          '/penerimaanWarga': (context) => PenerimaanWargaPage(),
        },
      ),
    );
  }
}
