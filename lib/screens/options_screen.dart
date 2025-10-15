import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_settings.dart';
import '../l10n/app_localizations.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Idioma
            ListTile(
              title: Text(loc.language),
              trailing: DropdownButton<String>(
                value: settings.language,
                items: const [
                  DropdownMenuItem(value: "Português", child: Text("Português")),
                  DropdownMenuItem(value: "Inglês", child: Text("Inglês")),
                  DropdownMenuItem(value: "Espanhol", child: Text("Español")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settings.updateLanguage(value);
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // Usar Timer
            SwitchListTile(
              title: Text(loc.useTimer),
              value: settings.useTimer,
              onChanged: (value) {
                settings.updateTimer(value, settings.timerCrescente);
              },
            ),

            // Timer Crescente
            SwitchListTile(
              title: Text(loc.timerAscending),
              value: settings.timerCrescente,
              onChanged: (value) {
                settings.updateTimer(settings.useTimer, value);
              },
            ),

            const SizedBox(height: 20),

            // Tema
            ListTile(
              title: Text(loc.theme),
              trailing: DropdownButton<ThemeMode>(
                value: settings.themeMode,
                items: const [
                  DropdownMenuItem(value: ThemeMode.light, child: Text("Claro")),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text("Escuro")),
                  DropdownMenuItem(value: ThemeMode.system, child: Text("Sistema")),
                ],
                onChanged: (mode) {
                  if (mode != null) settings.updateTheme(mode);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Qualidade do vídeo
            ListTile(
              title: Text(loc.videoQuality),
              trailing: DropdownButton<String>(
                value: settings.videoQuality,
                items: const [
                  DropdownMenuItem(value: "Baixa", child: Text("Baixa")),
                  DropdownMenuItem(value: "Média", child: Text("Média")),
                  DropdownMenuItem(value: "Alta", child: Text("Alta")),
                  DropdownMenuItem(value: "4K", child: Text("4K")),
                ],
                onChanged: (quality) {
                  if (quality != null) settings.updateVideoQuality(quality);
                },
              ),
            ),

            const SizedBox(height: 30),

            // Botão de salvar
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(loc.saveSettings),
              onPressed: () async {
                await settings.saveSettings();
                if (!mounted) return; // ✅ Proteção contra contexto inválido
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.savedSuccess)),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}