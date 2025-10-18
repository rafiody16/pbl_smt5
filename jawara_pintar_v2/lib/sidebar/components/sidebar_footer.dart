import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarFooter extends StatelessWidget {
  final String userEmail;
  final bool isExpanded;
  final VoidCallback onTap;

  const SidebarFooter({
    super.key,
    required this.userEmail,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              "Admin Jawara",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              userEmail,
              style: GoogleFonts.poppins(),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}