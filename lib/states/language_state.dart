import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider =
    ChangeNotifierProvider.autoDispose((ref) => LanguageState());

class LanguageState extends ChangeNotifier {
  static const String _languagePreferenceKey = 'app_language';
  static const String ENGLISH = 'en';
  static const String TIBETAN = 'bo';

  LanguageState() {
    _loadLanguage();
  }

  String? _currentLanguage;

  String get currentLanguage => _currentLanguage ?? TIBETAN;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languagePreferenceKey) ?? TIBETAN;
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languagePreferenceKey, language);
      notifyListeners();
    }
  }
}
