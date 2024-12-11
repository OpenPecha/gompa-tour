import 'package:flutter/material.dart';

class LocalizationHelper {
  static String getLocalizedText(
    BuildContext context, {
    required String enText,
    required String tbText,
    String? defaultText,
    int? maxLength, // Added maxLength parameter
  }) {
    final locale = Localizations.localeOf(context);
    String localizedText;

    if (locale.languageCode == 'en') {
      localizedText = enText;
    } else if (locale.languageCode == 'bo') {
      localizedText = tbText;
    } else {
      localizedText = defaultText ?? enText; // Fallback to English if no match
    }

    if (maxLength != null && localizedText.length > maxLength) {
      return "${localizedText.substring(0, maxLength)}...";
    }

    return localizedText.replaceAll(RegExp(r'\\r\\n|\\n'), '\n');
  }

  static double? getLocalizedHeight(BuildContext buildContext) {
    final locale = Localizations.localeOf(buildContext);
    return locale.languageCode == 'bo' ? 2.0 : null;
  }
}

// Extension method for easier access
extension LocalizedTextExtension on BuildContext {
  String localizedText({
    required String enText,
    required String boText,
    String? defaultText,
    int? maxLength, // Added maxLength parameter
  }) {
    return LocalizationHelper.getLocalizedText(
      this,
      enText: enText,
      tbText: boText,
      defaultText: defaultText,
      maxLength: maxLength, // Pass maxLength to the helper method
    );
  }

  double? getLocalizedHeight() {
    return LocalizationHelper.getLocalizedHeight(
      this,
    );
  }
}
