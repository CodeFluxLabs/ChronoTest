import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = AppSettings();
  await settings.loadSettings(); // Carrega configurações salvas

  runApp(
    ChangeNotifierProvider<AppSettings>.value(
      value: settings,
      child: const ChronoTestApp(),
    ),
  );
}

class ChronoTestApp extends StatelessWidget {
  const ChronoTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Chrono Test',
          debugShowCheckedModeBanner: false,
          themeMode: settings.themeMode,
          theme: ThemeData(
            primaryColor: const Color(0xFF1565C0),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1565C0),
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData.dark(),

          // 🌐 Suporte a idiomas
          locale: Locale(settings.languageCode),
          supportedLocales: [
            const Locale('pt'),
            const Locale('en'),
            const Locale('es'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate, // ✅ Delegate gerado para textos traduzidos
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: const SplashScreen(),
        );
      },
    );
  }
}