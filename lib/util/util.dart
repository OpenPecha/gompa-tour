import 'package:flutter/material.dart';

showGonpaSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

bool isValidUrl(String url) {
  final urlPattern = RegExp(
    r'^(https?:\/\/)?' // Protocol (optional)
    r'(www\.)?' // www. (optional)
    r'([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}' // Domain
    r'(\/[-a-zA-Z0-9()@:%_\+.~#?&//=]*)?$', // Path (optional)
    caseSensitive: false,
    multiLine: false,
  );

  return urlPattern.hasMatch(url);
}
