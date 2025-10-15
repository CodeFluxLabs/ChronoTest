import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import '../l10n/app_localizations.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  CameraController? _controller;
  bool isRecording = false;
  String testName = '';
  int duration = 2; // minutos
  int interval = 1; // minutos
  String? videoPath;
  String? folderPath;
  Timer? _snapshotTimer;
  Timer? _timerCrescente;
  String screenEventText = '';
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    // Escuta eventos de gravação de tela
    screenListener.addScreenRecordListener((recorded) {
      if (!mounted) return;
      setState(() {
        screenEventText = recorded
            ? "🟥 ${AppLocalizations.of(context)!.screenRecordingStarted}"
            : "⬛ ${AppLocalizations.of(context)!.screenRecordingStopped}";
      });
      debugPrint(screenEventText);
    });

    // Escuta eventos de captura de tela
    screenListener.addScreenShotListener((filePath) {
      if (!mounted) return;
      setState(() {
        screenEventText =
            "📸 ${AppLocalizations.of(context)!.screenshotSaved}: $filePath";
      });
      debugPrint(screenEventText);
    });

    screenListener.watch();
  }

  Future<void> _initializeCamera() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();
    final storageStatus = await Permission.manageExternalStorage.request();

    if (!cameraStatus.isGranted ||
        !micStatus.isGranted ||
        !storageStatus.isGranted) {
      debugPrint("❌ Permissões não concedidas");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.permissionsNotGranted),
        ),
      );
      return;
    }

    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _controller!.initialize();
      debugPrint("✅ Câmera inicializada");
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("❌ Erro ao inicializar câmera: $e");
    }
  }

  Future<String> _createChronoTestFolder(String name) async {
    final baseFolder = Directory('/storage/emulated/0/DCIM/ChronoTest');
    if (!await baseFolder.exists()) await baseFolder.create(recursive: true);

    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(":", "")
        .replaceAll("-", "")
        .split(".")
        .first;
    final testFolderName = '${timestamp}_$name';
    final testFolder = Directory('${baseFolder.path}/$testFolderName');
    if (!await testFolder.exists()) await testFolder.create(recursive: true);

    return testFolder.path;
  }

  void _startRecording() async {
    debugPrint("🎬 Botão de gravação pressionado");

    if (interval <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.invalidInterval)),
      );
      debugPrint("⚠️ Intervalo inválido: $interval");
      return;
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      debugPrint("❌ Câmera não está pronta");
      return;
    }

    if (_controller!.value.isRecordingVideo) {
      debugPrint("⚠️ Já está gravando");
      return;
    }

    folderPath = await _createChronoTestFolder(testName);
    videoPath = '$folderPath/video.mp4';

    try {
      debugPrint("🎥 Iniciando gravação...");
      await Future.delayed(const Duration(milliseconds: 500));
      await _controller!.startVideoRecording();
      debugPrint("✅ Gravação iniciada");

      isRecording = true;
      elapsedSeconds = 0;
      setState(() {});

      _startSnapshotTimer();
      _startTimerCrescente();

      Future.delayed(Duration(minutes: duration), () {
        if (isRecording) _stopRecording();
      });
    } catch (e) {
      debugPrint("❌ Erro ao iniciar gravação: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.recordingFailed)),
      );
    }
  }

  void _startSnapshotTimer() {
    _snapshotTimer = Timer.periodic(Duration(minutes: interval), (timer) async {
      if (!isRecording || _controller == null || !_controller!.value.isInitialized) return;

      try {
        final image = await _controller!.takePicture();
        final timestamp = DateTime.now()
            .toIso8601String()
            .replaceAll(":", "")
            .replaceAll("-", "");
        final imagePath = '$folderPath/frame_$timestamp.jpg';
        await image.saveTo(imagePath);
        debugPrint("📸 Foto capturada em: $imagePath");
      } catch (e) {
        debugPrint("❌ Erro ao capturar foto: $e");
      }
    });
  }

  void _startTimerCrescente() {
    _timerCrescente?.cancel();
    _timerCrescente = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isRecording) {
        setState(() {
          elapsedSeconds++;
        });
      }
    });
  }

  void _stopRecording() async {
  if (_controller == null || !_controller!.value.isRecordingVideo) {
    debugPrint("⚠️ Nenhuma gravação ativa para parar");
    return;
  }

  try {
    debugPrint("🛑 Parando gravação...");
    final file = await _controller!.stopVideoRecording();

    if (!mounted) return; // ✅ Verifica após await
    debugPrint("✅ Gravação parada. Arquivo temporário: ${file.path}");

    if (videoPath != null) {
      await file.saveTo(videoPath!);
      if (!mounted) return; // ✅ Verifica novamente após await
      debugPrint("📁 Vídeo salvo em: $videoPath");
    }

    isRecording = false;
    _snapshotTimer?.cancel();
    _timerCrescente?.cancel();
    if (!mounted) return; // ✅ Antes de usar setState
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.recordingFinished)),
    );

    Navigator.pop(context);
  } catch (e) {
    debugPrint("❌ Erro ao parar gravação: $e");
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.finalizeRecordingFailed)),
    );
  }
}

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _snapshotTimer?.cancel();
    _timerCrescente?.cancel();
    _controller?.dispose();
    screenListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
  canPop: !isRecording,
  onPopInvoked: (didPop) {
    if (!didPop && isRecording && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.finishRecordingPrompt)),
      );
    }
  },
  child: Scaffold(

    appBar: AppBar(title: Text(loc.newRecording)),
    body: Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CameraPreview(_controller!),
              if (isRecording)
                Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "${loc.recording}: ${_formatTime(elapsedSeconds)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                enabled: !isRecording,
                onChanged: (v) => testName = v,
                decoration: InputDecoration(
                  labelText: loc.testName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                enabled: !isRecording,
                keyboardType: TextInputType.number,
                onChanged: (v) => duration = int.tryParse(v) ?? 2,
                decoration: InputDecoration(
                  labelText: loc.videoDuration,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                enabled: !isRecording,
                keyboardType: TextInputType.number,
                onChanged: (v) => interval = int.tryParse(v) ?? 1,
                decoration: InputDecoration(
                  labelText: loc.photoInterval,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(isRecording ? Icons.stop : Icons.videocam),
                label: Text(
                  isRecording ? loc.stopRecording : loc.startRecording,
                ),
                onPressed: isRecording ? _stopRecording : _startRecording,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (screenEventText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    screenEventText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  ),
);
}
}