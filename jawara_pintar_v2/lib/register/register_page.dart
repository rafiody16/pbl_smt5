import 'package:flutter/material.dart';
import 'register_header.dart';
import 'register_form.dart';
import 'register_footer.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: const [
              RegisterHeader(),
              SizedBox(height: 32),
              RegisterForm(),
              SizedBox(height: 16),
              RegisterFooter(),
            ],
          ),
        ),
      ),
    );
  }
}