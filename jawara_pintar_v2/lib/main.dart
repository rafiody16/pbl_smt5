import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_pintar_v2/views/pengguna/pages/buat_akun_warga_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// === IMPORT PROVIDERS ===
import 'providers/auth_provider.dart';
import 'providers/warga_provider.dart';
import 'providers/keuangan_provider.dart';
import 'providers/produk_provider.dart'; // PENTING: Tambahkan ini
import 'providers/kegiatan_provider.dart';
import 'providers/broadcast_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/cart_provider.dart';

// === IMPORT SERVICES ===
import 'services/preferences_service.dart';

// === IMPORT HALAMAN ===
import 'login/login_page.dart';
import 'register/register_page.dart';
import 'kegiatan/kegiatan_page.dart';
import 'kegiatan/kegiatan_tambah_page.dart';
import 'broadcast/broadcast_daftar_page.dart';
import 'broadcast/broadcast_tambah_page.dart';
import 'log_aktivitas/log_aktivitas_page.dart';
import 'pesan_warga/pesan_warga_page.dart';
import 'dashboard/keuangan.dart';
import 'penerimaanWarga/pages/penerimaan_warga_page.dart';
import 'marketplace/pages/marketplace_list.dart';
import 'marketplace/pages/produk_form_page.dart';
import 'marketplace/pages/cart_page.dart';

// Import Warga (New Structure)
import 'views/warga/pages/warga_list_page.dart';
import 'views/warga/pages/warga_form_page.dart';
import 'views/warga/pages/warga_detail_page.dart';

// Import Pengguna (User Management)
import 'views/pengguna/pages/pengguna_list_page.dart';
import 'views/pengguna/pages/pengguna_detail_page.dart';
import 'views/pengguna/pages/pengguna_edit_page.dart';

// Import Kegiatan (New Views)
import 'views/kegiatan/kegiatan_list_page.dart';
import 'views/kegiatan/kegiatan_form_page.dart';
// Import Broadcast (New Views)
import 'views/broadcast/broadcast_list_page.dart';
import 'views/broadcast/broadcast_form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi PreferencesService (HARUS PERTAMA)
  await PreferencesService().init();

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
        ChangeNotifierProvider(create: (_) => KegiatanProvider()),
        ChangeNotifierProvider(create: (_) => BroadcastProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),

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
          '/dashboard': (context) => const DashboardPage(),
          // Kegiatan (New Routes)
          '/kegiatan/list': (context) => const KegiatanListPage(),
          '/kegiatan/form': (context) => const KegiatanFormPage(),
          // Broadcast (New Routes)
          '/broadcast/list': (context) => const BroadcastListPage(),
          '/broadcast/form': (context) => const BroadcastFormPage(),
          '/broadcast': (context) => const BroadcastDaftarPage(),
          '/broadcast/tambah': (context) => const BroadcastTambahPage(),
          '/log': (context) => const LogDaftarPage(),
          '/aspirasi': (context) => const AspirasiDaftarPage(),

          // Routes Warga (New)
          '/warga/list': (context) => const WargaListPage(),
          '/warga/add': (context) => const WargaFormPage(),
          '/warga/edit': (context) => const WargaFormPage(isEdit: true),
          '/warga/detail': (context) => const WargaDetailPage(),

          // Routes Pengguna (User Management)
          '/pengguna/list': (context) => const PenggunaListPage(),
          '/pengguna/add': (context) => const BuatAkunWargaPage(),
          '/pengguna/edit': (context) => const PenggunaEditPage(),

          '/marketplace/list': (context) => const MarketplaceListPage(),
          '/produk/add': (context) => const ProdukFormPage(),
          '/cart/list': (context) => const CartPage(),

          // Routes Lainnya
          '/penerimaanWarga': (context) => PenerimaanWargaPage(),
        },
      ),
    );
  }
}
