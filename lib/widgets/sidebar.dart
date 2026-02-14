import 'package:flutter/material.dart';
import 'package:quotation_invoice/setting_page.dart';
import '../business_profile_list.dart';
import 'package:quotation_invoice/client_list_page.dart';
import '../user_profile_page.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Using the professional Slate color you liked
    const Color sidebarColor = Color(0xff1f2937);

    return Container(
      width: 100,
      color: sidebarColor,
      child: Column(
        children: [
          const SizedBox(height: 50),
          _buildNavIcon(
            context,
            icon: Icons.person,
            label: "User",
            destination: const UserProfilePage(
              username: '',
              email: '',
              password: '',
            ),
          ),
          const SizedBox(height: 30),
          _buildNavIcon(
            context,
            icon: Icons.business,
            label: "Profile",
            destination: const BusinessProfileListPage(),
          ),
          const SizedBox(height: 30),
          _buildNavIcon(
            context,
            icon: Icons.people_alt_outlined,
            label: "Clients",
            destination: const ClientListPage(),
          ),
          //const SizedBox(height: 30),
          //_buildNavIcon(
          //context,
          //icon: Icons.description_outlined,
          //label: "Invoice",
          // This takes you to the client list to start an invoice
          //destination: const ClientListPage(),
          //),
          const Spacer(),
          _buildNavIcon(
            context,
            icon: Icons.settings_outlined,
            label: "Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              ); // Add settings logic here
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper method to keep code clean and prevent errors
  Widget _buildNavIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? destination,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap:
          onTap ??
          () {
            if (destination != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            }
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
