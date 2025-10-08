import 'package:flutter/material.dart';
import 'screens/SplashScreen.dart';// nova tela de abertura

void main() {
  runApp(const ChronoTestApp());
}

class ChronoTestApp extends StatelessWidget {
  const ChronoTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrono Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1565C0),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(), // inicia com a tela de splash
    );
  }
}