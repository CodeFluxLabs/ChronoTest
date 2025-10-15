// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chrono Test';

  @override
  String get settings => 'Settings';

  @override
  String get start => 'New Recording';

  @override
  String get stop => 'Stop';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get videoQuality => 'Video Quality';

  @override
  String get useTimer => 'Use Timer';

  @override
  String get timerAscending => 'Ascending Timer';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get savedSuccess => 'Settings saved successfully';

  @override
  String get history => 'History';

  @override
  String get noTestsFound => 'No tests found for this day';

  @override
  String get storagePermissionRequired => 'Storage permission is required';

  @override
  String get recordingWarning => 'Finish the recording before exiting';

  @override
  String get recordingStatus => '⏱ Recording';

  @override
  String get testName => 'Test name';

  @override
  String get videoDuration => 'Video duration (minutes)';

  @override
  String get photoInterval => 'Photo interval (minutes)';

  @override
  String get stopRecording => 'Stop Recording';

  @override
  String get startRecording => 'Start Recording';

  @override
  String get newRecording => 'New Recording';

  @override
  String get finishRecordingPrompt => 'Finish the recording before exiting';

  @override
  String get recording => '⏱ Recording';

  @override
  String get permissionsNotGranted => 'Permissions not granted';

  @override
  String get invalidInterval => 'Invalid interval';

  @override
  String get recordingFailed => 'Failed to start recording';

  @override
  String get recordingFinished => 'Recording finished';

  @override
  String get finalizeRecordingFailed => 'Failed to finalize recording';

  @override
  String get screenRecordingStarted => 'Screen recording started';

  @override
  String get screenRecordingStopped => 'Screen recording stopped';

  @override
  String get screenshotSaved => 'Screenshot saved';
}
