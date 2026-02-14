import 'package:flutter/material.dart';
import 'package:quotation_invoice/screens/splash_screen.dart';
//import 'screens/login.dart';
//import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // 👈 Start here
    );
  }
}
