import 'dart:io';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'video_view_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime selectedDay = DateTime.now();
  Map<DateTime, List<File>> testsByDate = {};

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  void _loadTests() {
    final baseDir = Directory('/storage/emulated/0/ChronoTest/');
    if (!baseDir.existsSync()) return;

    final folders = baseDir.listSync().whereType<Directory>().toList();
    for (var folder in folders) {
      try {
        final folderName = folder.path.split('/').last;
        final dateStr = folderName.split('_').first;
        final date = DateTime.parse(dateStr);

        final files = folder
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.mp4') || f.path.endsWith('.jpg'))
            .toList();

        files.sort((a, b) => a.path.compareTo(b.path));

        if (files.isNotEmpty) {
          testsByDate.update(date, (existing) => [...existing, ...files],
              ifAbsent: () => files);
        }
      } catch (e) {
        debugPrint("Erro ao processar pasta: ${folder.path}");
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tests = testsByDate[selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico")),
      body: Column(
        children: [
          TableCalendar(
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
            child: tests.isEmpty
                ? const Center(child: Text("Nenhum teste encontrado para este dia"))
                : ListView.builder(
                    itemCount: tests.length,
                    itemBuilder: (context, index) {
                      final file = tests[index];
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
          ),
        ],
      ),
    );
  }
}