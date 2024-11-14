import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AutoDisposeChangeNotifierProvider<ThemeModeState> themeProvider =
    ChangeNotifierProvider.autoDispose((ref) {
  return ThemeModeState();
});

class ThemeModeState extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';

  ThemeModeState() {
    _loadThemeMode();
  }

  ThemeMode? _themeMode;

  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode();
    notifyListeners();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = prefs.getString(_themePreferenceKey);
    if (modeString != null) {
      switch (modeString) {
        case 'ThemeMode.dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'ThemeMode.light':
          _themeMode = ThemeMode.light;
          break;
        case 'ThemeMode.system':
          _themeMode = ThemeMode.system;
          break;
      }
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, _themeMode.toString());
  }
}
