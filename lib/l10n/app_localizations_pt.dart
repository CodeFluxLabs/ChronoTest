// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Teste Cronômetro';

  @override
  String get settings => 'Configurações';

  @override
  String get start => 'Nova Gravação';

  @override
  String get stop => 'Parar';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get videoQuality => 'Qualidade do vídeo';

  @override
  String get useTimer => 'Usar Timer';

  @override
  String get timerAscending => 'Timer Crescente';

  @override
  String get saveSettings => 'Salvar Configurações';

  @override
  String get savedSuccess => 'Configurações salvas com sucesso';

  @override
  String get history => 'Histórico';

  @override
  String get noTestsFound => 'Nenhum teste encontrado para este dia';

  @override
  String get storagePermissionRequired =>
      'Permissão de armazenamento é necessária';

  @override
  String get recordingWarning => 'Finalize a gravação antes de sair';

  @override
  String get recordingStatus => '⏱ Gravando';

  @override
  String get testName => 'Nome do teste';

  @override
  String get videoDuration => 'Duração do vídeo (minutos)';

  @override
  String get photoInterval => 'Intervalo entre fotos (minutos)';

  @override
  String get stopRecording => 'Parar Gravação';

  @override
  String get startRecording => 'Iniciar Gravação';

  @override
  String get newRecording => 'Nova Gravação';

  @override
  String get finishRecordingPrompt => 'Finalize a gravação antes de sair';

  @override
  String get recording => '⏱ Gravando';

  @override
  String get permissionsNotGranted => 'Permissões não concedidas';

  @override
  String get invalidInterval => 'Intervalo inválido';

  @override
  String get recordingFailed => 'Erro ao iniciar gravação';

  @override
  String get recordingFinished => 'Gravação finalizada';

  @override
  String get finalizeRecordingFailed => 'Erro ao finalizar gravação';

  @override
  String get screenRecordingStarted => 'Gravação de tela iniciada';

  @override
  String get screenRecordingStopped => 'Gravação de tela encerrada';

  @override
  String get screenshotSaved => 'Captura de tela salva';
}
