import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/repo/api_repository.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/states/pilgrim_site_state.dart';
import 'package:gompa_tour/states/statue_state.dart';

// Update the SearchNotifier to use the new state
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository repository;

  SearchNotifier(this.repository) : super(const SearchState());

  Future<void> searchAcrossTables(String query) async {
    if (query.isEmpty) {
      state = const SearchState();
      return;
    }

    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      final results = await repository.searchAcrossTables(query);
      state = state.copyWith(
        results: results,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearSearchResults() {
    state = const SearchState();
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(
    ref.read(statueNotifierProvider.notifier),
    ref.read(gonpaNotifierProvider.notifier),
    ref.read(pilgrimSiteNotifierProvider.notifier),
    ref.read(festivalNotifierProvider.notifier),
  );
});

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNotifier(repository);
});

class SearchState {
  final List<dynamic> results;
  final bool isLoading;
  final String? error;

  const SearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    List<dynamic>? results,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
