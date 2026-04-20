import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/settings/presentation/providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(settings.themeMode.name),
            onTap: () => _pickTheme(context, ref),
          ),
          SwitchListTile(
            title: const Text('Default grid layout'),
            value: settings.useGridLayout,
            onChanged: (v) => ref.read(settingsProvider.notifier).setLayout(v),
          ),
          SwitchListTile(
            title: const Text('Autosave'),
            value: settings.autoSave,
            onChanged: (v) => ref.read(settingsProvider.notifier).setAutosave(v),
          ),
          const AboutListTile(
            applicationName: 'NoteFlow',
            applicationVersion: '1.0.0',
            aboutBoxChildren: [Text('Local-first note app with lightweight clean architecture.')],
          ),
          const ListTile(title: Text('Backup / Export / Import'), subtitle: Text('Placeholder for future implementation')),
        ],
      ),
    );
  }

  Future<void> _pickTheme(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('System'),
            onTap: () {
              ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.system);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Light'),
            onTap: () {
              ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Dark'),
            onTap: () {
              ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
