import 'package:flutter/material.dart';
import '../screens/record_screen.dart';
import '../screens/history_screen.dart';
import '../screens/options_screen.dart';
import '../l10n/app_localizations.dart'; // ✅ Importação do sistema de tradução

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // ✅ Atalho para os textos traduzidos

    return Scaffold(
      appBar: AppBar(title: Text(loc.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botão Nova Gravação
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecordScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.videocam),
              label: Text(loc.start), // ✅ Usando tradução
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
            ),

            const SizedBox(height: 24),

            // Botão Histórico
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(loc.history), // ✅ Usando tradução
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
            ),

            const SizedBox(height: 24),

            // Botão Opções
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OptionsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: Text(loc.settings), // ✅ Usando tradução
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}