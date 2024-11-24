import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recentSearchesProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  return RecentSearchesNotifier();
});

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier() : super([]) {
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('recent_searches') ?? [];
    state = searches;
  }

  Future<void> addSearch(String search) async {
    if (!state.contains(search)) {
      final updatedSearches = [...state, search];
      state = updatedSearches;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', updatedSearches);
    }
  }

  Future<void> removeSearch(String search) async {
    final updatedSearches = state.where((s) => s != search).toList();
    state = updatedSearches;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', updatedSearches);
  }
}
