import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login/login_page.dart';
import 'register/register_page.dart';
import 'package:jawara_pintar_v2/manajemen_pengguna/halaman_daftar_pengguna.dart';


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
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/daftarPengguna': (context) => const UserListScreen(),
      },
    );
  }
}