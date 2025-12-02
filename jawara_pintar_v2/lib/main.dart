import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login/login_page.dart';
import 'register/register_page.dart';
import 'package:jawara_pintar_v2/manajemen_pengguna/halaman_daftar_pengguna.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'kegiatan/kegiatan_page.dart';
import 'kegiatan/kegiatan_tambah_page.dart';
import 'broadcast/broadcast_daftar_page.dart';
import 'broadcast/broadcast_tambah_page.dart';
import 'log_aktivitas/log_aktivitas_page.dart';
import 'pesan_warga/pesan_warga_page.dart';
import 'dashboard/keuangan.dart';
import 'warga/pages/warga_daftar_page.dart';
import 'warga/pages/warga_tambah_page.dart';
import 'warga/pages/keluarga.dart';
import 'warga/pages/rumah_daftar_page.dart';
import 'warga/pages/rumah_tambah_page.dart';
import 'penerimaanWarga/pages/penerimaan_warga_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/warga_provider.dart';
import 'views/warga/pages/warga_list_page.dart';
import 'views/warga/pages/warga_form_page.dart';
import 'views/warga/pages/warga_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://oacynurgiosfrdujfnxz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hY3ludXJnaW9zZnJkdWpmbnh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2MzEwMDcsImV4cCI6MjA4MDIwNzAwN30.I3sA09SjQftcb0OJ-GS3Qet9nb_wSc3XtqrnNNiMvLM',
  );
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WargaProvider())],
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

        home: const DashboardPage(),

        // home: const LoginPage(),
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
          // New routes using Provider
          '/warga/list': (context) => const WargaListPage(),
          '/warga/add': (context) => const WargaFormPage(),
          '/warga/edit': (context) => const WargaFormPage(isEdit: true),
          '/warga/detail': (context) => const WargaDetailPage(),
          // Old routes for backward compatibility
          // '/warga': (context) => const WargaDaftarPage(),
          // '/warga/tambah': (context) => const WargaTambahPage(),
          // '/keluarga': (context) => const KeluargaDaftarPage(),
          // '/rumah': (context) => const RumahDaftarPage(),
          // '/eumah/tambah': (context) => RumahTambahPage(),
          '/penerimaanWarga': (context) => PenerimaanWargaPage(),
        },
      ),
    );
  }
}
