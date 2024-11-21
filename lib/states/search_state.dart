import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repo/database_repository.dart';
import 'database_state.dart';

class SearchNotifier extends StateNotifier<List<dynamic>> {
  final SearchRepository repository;

  SearchNotifier(this.repository) : super([]);

  Future<void> searchAcrossTables(String query) async {
    if (query.isEmpty) {
      state = [];
      return;
    }

    final results = await repository.searchAcrossTables(query);
    state = results;
  }

  void clearSearchResults() {
    state = [];
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dbHelper = ref.read(databaseHelperProvider);
  return SearchRepository(
    dbHelper: dbHelper,
  );
});

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, List<dynamic>>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNotifier(repository);
});
