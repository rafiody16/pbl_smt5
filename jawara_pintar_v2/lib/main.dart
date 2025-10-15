import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login/login_page.dart';
import 'register/register_page.dart';
import 'kegiatan/kegiatan_page.dart';

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
        '/kegiatan': (context) => const KegiatanPage(),
      },
    );
  }
}
