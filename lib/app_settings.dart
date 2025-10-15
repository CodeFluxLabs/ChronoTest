import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool _useTimer = true;
  bool _timerCrescente = true;
  ThemeMode _themeMode = ThemeMode.system;
  String _language = "Português";
  String _videoQuality = "Alta";

  bool get useTimer => _useTimer;
  bool get timerCrescente => _timerCrescente;
  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  String get videoQuality => _videoQuality;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _useTimer = prefs.getBool('useTimer') ?? true;
    _timerCrescente = prefs.getBool('timerCrescente') ?? true;
    _language = prefs.getString('language') ?? "Português";
    _videoQuality = prefs.getString('videoQuality') ?? "Alta";

    final themeIndex = prefs.getInt('themeMode') ?? 2;
    _themeMode = ThemeMode.values[themeIndex];

    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useTimer', _useTimer);
    await prefs.setBool('timerCrescente', _timerCrescente);
    await prefs.setString('language', _language);
    await prefs.setString('videoQuality', _videoQuality);
    await prefs.setInt('themeMode', ThemeMode.values.indexOf(_themeMode));
  }

  void updateTimer(bool use, bool crescente) {
    _useTimer = use;
    _timerCrescente = crescente;
    notifyListeners();
  }

  void updateTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void updateLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void updateVideoQuality(String quality) {
    _videoQuality = quality;
    notifyListeners();
  }
  String get languageCode {
  switch (_language) {
    case 'Português': return 'pt';
    case 'Inglês': return 'en';
    case 'Espanhol': return 'es';
    default: return 'pt';
  }
}

}