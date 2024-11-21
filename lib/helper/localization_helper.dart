import 'package:flutter/material.dart';

class LocalizationHelper {
  static String getLocalizedText(
    BuildContext context, {
    required String enText,
    required String tbText,
    String? defaultText,
  }) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'en') {
      return enText;
    } else if (locale.languageCode == 'bo') {
      return tbText;
    }
    return defaultText ?? enText; // Fallback to English if no match
  }
}

// Extension method for easier access
extension LocalizedTextExtension on BuildContext {
  String localizedText({
    required String enText,
    required String boText,
    String? defaultText,
  }) {
    return LocalizationHelper.getLocalizedText(
      this,
      enText: enText,
      tbText: boText,
      defaultText: defaultText,
    );
  }
}
