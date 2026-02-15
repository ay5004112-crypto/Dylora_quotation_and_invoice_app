import 'package:flutter/material.dart';
import 'package:quotation_invoice/screens/splash_screen.dart';
//import 'screens/login.dart';
//import 'splash_screen.dart';
//final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
//final ValueNotifier<bool> notificationsEnabled = ValueNotifier(true);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  get mode => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
      //darkTheme: ThemeData.dark(useMaterial3: true),
      //themeMode: mode,
      
      home: const SplashScreen(), // 👈 Start here
    );
  }
}
