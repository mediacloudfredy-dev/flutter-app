import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPrefsService {
  static const _onboardingDone = 'onboardingDone';
  static const _themeMode = 'themeMode';
  static const _layoutGrid = 'layoutGrid';

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingDone) ?? false;
  }

  Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingDone, true);
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeMode, mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_themeMode);
    return ThemeMode.values.firstWhere((e) => e.name == raw, orElse: () => ThemeMode.system);
  }

  Future<void> saveGridLayout(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_layoutGrid, value);
  }

  Future<bool> loadGridLayout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_layoutGrid) ?? false;
  }
}
