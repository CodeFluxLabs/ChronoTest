import 'dart:io';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'video_view_screen.dart';
import '../l10n/app_localizations.dart'; // ✅ Importação do sistema de tradução

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime selectedDay = DateTime.now();
  Map<DateTime, Map<String, List<File>>> testsByDateAndName = {};

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoad();
  }

  void _requestPermissionAndLoad() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted || await Permission.storage.request().isGranted) {
      _loadTests();
    } else {
      debugPrint("❌ Permissão de armazenamento negada");
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.storagePermissionRequired)),
        );
      }
    }
  }

  void _loadTests() {
    final baseDir = Directory('/storage/emulated/0/DCIM/ChronoTest/');
    if (!baseDir.existsSync()) {
      debugPrint("❌ Pasta base não encontrada: ${baseDir.path}");
      return;
    }

    final folders = baseDir.listSync().whereType<Directory>().toList();
    for (var folder in folders) {
      try {
        final folderName = folder.path.split('/').last;
        final parts = folderName.split('_');

        String testName;
        DateTime date;

        if (parts.length >= 2) {
          final dateStr = parts[0];
          final fullDate = _parseFolderDate(dateStr);
          date = DateTime(fullDate.year, fullDate.month, fullDate.day);
          testName = parts.sublist(1).join('_');
        } else {
          final fallbackDate = folder.statSync().modified;
          date = DateTime(fallbackDate.year, fallbackDate.month, fallbackDate.day);
          testName = folderName;
        }

        final files = folder
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.mp4') || f.path.endsWith('.jpg'))
            .toList();

        files.sort((a, b) => a.path.compareTo(b.path));

        if (files.isNotEmpty) {
          testsByDateAndName.putIfAbsent(date, () => {});
          testsByDateAndName[date]!.update(testName, (existing) => [...existing, ...files],
              ifAbsent: () => files);
        }
      } catch (e) {
        debugPrint("❌ Erro ao processar pasta: ${folder.path}");
      }
    }

    setState(() {});
  }

  DateTime _parseFolderDate(String raw) {
    try {
      final cleaned = raw.replaceFirst('T', '');
      final year = int.parse(cleaned.substring(0, 4));
      final month = int.parse(cleaned.substring(4, 6));
      final day = int.parse(cleaned.substring(6, 8));
      final hour = int.parse(cleaned.substring(8, 10));
      final minute = int.parse(cleaned.substring(10, 12));
      final second = int.parse(cleaned.substring(12, 14));
      return DateTime(year, month, day, hour, minute, second);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final normalizedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final testsForDay = testsByDateAndName[normalizedDay] ?? {};

    return Scaffold(
      appBar: AppBar(title: Text(loc.history)),
      body: Column(
        children: [
          TableCalendar(
            locale: loc.localeName, // ✅ idioma do calendário
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: selectedDay,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
              });
            },
          ),
          Expanded(
            child: testsForDay.isEmpty
                ? Center(child: Text(loc.noTestsFound))
                : ListView(
                    children: testsForDay.entries.map((entry) {
                      final testName = entry.key;
                      final files = entry.value;
                      return ListTile(
                        leading: const Icon(Icons.folder),
                        title: Text(testName),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TestDetailScreen(
                                testName: testName,
                                files: files,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class TestDetailScreen extends StatelessWidget {
  final String testName;
  final List<File> files;

  const TestDetailScreen({super.key, required this.testName, required this.files});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(testName)),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          final isVideo = file.path.endsWith('.mp4');
          return ListTile(
            leading: Icon(isVideo ? Icons.videocam : Icons.photo),
            title: Text(file.path.split('/').last),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              if (isVideo) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoViewScreen(videoFile: file),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: InteractiveViewer(
                      child: Image.file(file),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}