// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Prueba Cronómetro';

  @override
  String get settings => 'Configuraciones';

  @override
  String get start => 'Nueva Grabación';

  @override
  String get stop => 'Detener';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get videoQuality => 'Calidad de video';

  @override
  String get useTimer => 'Usar Temporizador';

  @override
  String get timerAscending => 'Temporizador Ascendente';

  @override
  String get saveSettings => 'Guardar Configuraciones';

  @override
  String get savedSuccess => 'Configuraciones guardadas con éxito';

  @override
  String get history => 'Historial';

  @override
  String get noTestsFound => 'No se encontraron pruebas para este día';

  @override
  String get storagePermissionRequired =>
      'Se requiere permiso de almacenamiento';

  @override
  String get recordingWarning => 'Finaliza la grabación antes de salir';

  @override
  String get recordingStatus => '⏱ Grabando';

  @override
  String get testName => 'Nombre de la prueba';

  @override
  String get videoDuration => 'Duración del video (minutos)';

  @override
  String get photoInterval => 'Intervalo entre fotos (minutos)';

  @override
  String get stopRecording => 'Detener Grabación';

  @override
  String get startRecording => 'Iniciar Grabación';

  @override
  String get newRecording => 'Nueva Grabación';

  @override
  String get finishRecordingPrompt => 'Finaliza la grabación antes de salir';

  @override
  String get recording => '⏱ Grabando';

  @override
  String get permissionsNotGranted => 'Permisos no concedidos';

  @override
  String get invalidInterval => 'Intervalo inválido';

  @override
  String get recordingFailed => 'Error al iniciar la grabación';

  @override
  String get recordingFinished => 'Grabación finalizada';

  @override
  String get finalizeRecordingFailed => 'Error al finalizar la grabación';

  @override
  String get screenRecordingStarted => 'Grabación de pantalla iniciada';

  @override
  String get screenRecordingStopped => 'Grabación de pantalla detenida';

  @override
  String get screenshotSaved => 'Captura de pantalla guardada';
}
