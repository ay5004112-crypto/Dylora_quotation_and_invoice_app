import 'package:flutter/material.dart';
import 'package:quotation_invoice/setting_page.dart';
import '../business_profile_list.dart';
import 'package:quotation_invoice/client_list_page.dart';
import '../user_profile_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    const Color navColor = Color(0xff1f2937); // same slate color

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: navColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const UserProfilePage(
                  username: '',
                  email: '',
                  password: '',
                ),
              ),
            );
            break;

          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BusinessProfileListPage()),
            );
            break;

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClientListPage()),
            );
            break;

          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "User",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: "Clients",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: "Settings",
        ),
      ],
    );
  }
}
