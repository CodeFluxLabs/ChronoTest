import 'package:flutter/material.dart';
import '../screens/record_screen.dart';
import '../screens/history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chrono Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              label: const Text("Nova Gravação"),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60)),
            ),
            const SizedBox(height: 24),
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
              label: const Text("Histórico"),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60)),
            ),
          ],
        ),
      ),
    );
  }
}
