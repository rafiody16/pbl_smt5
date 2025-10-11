import 'package:flutter/material.dart';
import 'login_header.dart';
import 'login_form.dart';
import 'login_footer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: const [
              LoginHeader(),
              SizedBox(height: 32),
              LoginForm(),
              SizedBox(height: 16),
              LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}