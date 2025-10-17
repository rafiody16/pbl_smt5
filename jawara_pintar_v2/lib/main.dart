import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login/login_page.dart';
import 'register/register_page.dart';
import 'kegiatan/kegiatan_page.dart';
import 'dashboard/dashboard_page.dart';
import 'warga/pages/warga_daftar_page.dart';
import 'warga/pages/warga_tambah_page.dart';
import 'warga/pages/keluarga.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

      home: const DashboardPage(userEmail: "admin@jawara.com"),
      // home: const LoginPage(),
      
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(userEmail: "admin@jawara.com"),
        '/kegiatan': (context) => const KegiatanPage(),
        '/warga': (context) => const WargaDaftarPage(),
        '/warga/tambah': (context) => const WargaTambahPage(),
        '/keluarga': (context) => const KeluargaDaftarPage(),
      },
    );
  }
}