import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/core/services/local_prefs_service.dart';
import 'package:noteflow/shared/models/app_settings.dart';

class SettingsNotifier extends Notifier<AppSettings> {
  final _prefs = LocalPrefsService();

  @override
  AppSettings build() {
    _load();
    return const AppSettings();
  }

  Future<void> _load() async {
    final theme = await _prefs.loadThemeMode();
    final grid = await _prefs.loadGridLayout();
    state = state.copyWith(themeMode: theme, useGridLayout: grid);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.saveThemeMode(mode);
  }

  Future<void> setLayout(bool useGrid) async {
    state = state.copyWith(useGridLayout: useGrid);
    await _prefs.saveGridLayout(useGrid);
  }

  void setAutosave(bool value) => state = state.copyWith(autoSave: value);
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
