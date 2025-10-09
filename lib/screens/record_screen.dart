import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_capture_event/screen_capture_event.dart';

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
  String screenEventText = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    screenListener.addScreenRecordListener((recorded) {
      setState(() {
        screenEventText = recorded
            ? "🟥 Gravação de tela iniciada"
            : "⬛ Gravação de tela encerrada";
      });
      debugPrint(screenEventText);
    });

    screenListener.addScreenShotListener((filePath) {
      setState(() {
        screenEventText = "📸 Screenshot salva em: $filePath";
      });
      debugPrint(screenEventText);
    });

    screenListener.watch();
  }

  Future<void> _initializeCamera() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();
    final storageStatus = await Permission.manageExternalStorage.request();

    if (!cameraStatus.isGranted || !micStatus.isGranted || !storageStatus.isGranted) {
      debugPrint("❌ Permissões não concedidas");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissões necessárias não concedidas")),
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

    final testFolderName = '${DateTime.now().toIso8601String().replaceAll(":", "").replaceAll("-", "").split(".").first}_$name';
    final testFolder = Directory('${baseFolder.path}/$testFolderName');
    if (!await testFolder.exists()) await testFolder.create(recursive: true);

    return testFolder.path;
  }

  void _startRecording() async {
  debugPrint("🎬 Botão de gravação pressionado");

  if (interval <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Intervalo entre fotos deve ser maior que 0 minuto")),
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
    setState(() {});
    _startSnapshotTimer();

    Future.delayed(Duration(minutes: duration), () {
      if (isRecording) _stopRecording();
    });
  } catch (e) {
    debugPrint("❌ Erro ao iniciar gravação: $e");
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Falha ao iniciar gravação")),
    );
  }
}

  void _startSnapshotTimer() {
    _snapshotTimer = Timer.periodic(Duration(minutes: interval), (timer) async {
      if (!isRecording || _controller == null || !_controller!.value.isInitialized) return;

      try {
        final image = await _controller!.takePicture();
        final timestamp = DateTime.now().toIso8601String().replaceAll(":", "").replaceAll("-", "");
        final imagePath = '$folderPath/frame_$timestamp.jpg';
        await image.saveTo(imagePath);
        debugPrint("📸 Foto capturada em: $imagePath");
      } catch (e) {
        debugPrint("❌ Erro ao capturar foto: $e");
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
      debugPrint("✅ Gravação parada. Arquivo temporário: ${file.path}");

      if (videoPath != null) {
        await file.saveTo(videoPath!);
        debugPrint("📁 Vídeo salvo em: $videoPath");
      }

      isRecording = false;
      _snapshotTimer?.cancel();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gravação finalizada e fotos capturadas!")),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint("❌ Erro ao parar gravação: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Falha ao finalizar gravação")),
      );
    }
  }

  @override
  void dispose() {
    _snapshotTimer?.cancel();
    _controller?.dispose();
    screenListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Nova Gravação")),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller!)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  enabled: !isRecording,
                  onChanged: (v) => testName = v,
                  decoration: const InputDecoration(
                    labelText: "Nome do teste",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  enabled: !isRecording,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => duration = int.tryParse(v) ?? 2,
                  decoration: const InputDecoration(
                    labelText: "Duração do vídeo (minutos)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  enabled: !isRecording,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => interval = int.tryParse(v) ?? 1,
                  decoration: const InputDecoration(
                    labelText: "Intervalo entre fotos (minutos)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(isRecording ? Icons.stop : Icons.videocam),
                  label: Text(isRecording ? "Parar Gravação" : "Iniciar Gravação"),
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
                      style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}