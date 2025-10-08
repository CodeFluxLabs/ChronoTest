import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart'; // substitua pelo nome da sua tela principal

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Oculta barra de status para tela cheia
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // Aguarda 3 segundos e navega para a tela principal
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 22, 39, 94), // fundo azul escuro
      body: Center(
        child: Image.asset(
          'assets/images/icon_app.png', // coloque sua imagem aqui
          width: 200,
        ),
      ),
    );
  }
}