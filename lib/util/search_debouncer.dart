import 'dart:async';

import 'package:flutter/material.dart';

class SearchDebouncer {
  Timer? _debounceTimer;
  final Duration delay;
  final int minLength;

  SearchDebouncer({
    this.delay = const Duration(milliseconds: 1200),
    this.minLength = 3,
  });

  void run(
    String query, {
    required Future<void> Function(String) onSearch,
    required Future<void> Function(String) onSaveSearch,
    required VoidCallback onClearResults,
  }) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // If query is empty
    if (query.isEmpty) {
      onClearResults();
      return;
    }

    // Create a new debounce timer
    _debounceTimer = Timer(delay, () async {
      // Perform search
      await onSearch(query);

      // Save search
      await onSaveSearch(query);
      // }
    });
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
