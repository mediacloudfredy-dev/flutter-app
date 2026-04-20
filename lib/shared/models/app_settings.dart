import 'package:flutter/material.dart';
import 'package:noteflow/shared/enums/note_sort.dart';

class AppSettings {
  final ThemeMode themeMode;
  final bool useGridLayout;
  final NoteSort defaultSort;
  final bool autoSave;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.useGridLayout = false,
    this.defaultSort = NoteSort.updatedDesc,
    this.autoSave = true,
  });

  AppSettings copyWith({ThemeMode? themeMode, bool? useGridLayout, NoteSort? defaultSort, bool? autoSave}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      useGridLayout: useGridLayout ?? this.useGridLayout,
      defaultSort: defaultSort ?? this.defaultSort,
      autoSave: autoSave ?? this.autoSave,
    );
  }
}
