import 'package:flutter/material.dart';
// import your global notifiers
import '../main.dart'; // or wherever themeNotifier & notificationsEnabled live

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🌙 Dark Mode
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, mode, _) {
              return ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text("Dark Mode"),
                trailing: Switch(
                  value: mode == ThemeMode.dark,
                  onChanged: (v) {
                    themeNotifier.value =
                        v ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              );
            },
          ),

          // 🔔 Notifications
          ValueListenableBuilder<bool>(
            valueListenable: notificationsEnabled,
            builder: (context, enabled, _) {
              return ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text("Notifications"),
                trailing: Switch(
                  value: enabled,
                  onChanged: (v) {
                    notificationsEnabled.value = v;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          v ? "Notifications enabled" : "Notifications disabled",
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text("Change Password"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Change password clicked")),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About App"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Invoice App",
                applicationVersion: "1.0.0",
              );
            },
          ),
        ],
      ),
    );
  }
}
