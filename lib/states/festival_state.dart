import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/models/festival_model.dart';
import 'package:gompa_tour/repo/database_repository.dart';

import 'database_state.dart';

class FestivalNotifier extends StateNotifier<FestivalListState> {
  final DatabaseRepository<Festival> repository;

  FestivalNotifier(this.repository) : super(FestivalListState.initial());

  Future<void> fetchInitialFestivals() async {
    state = state.copyWith(isLoading: true);
    try {
      final initialFestivals =
          await repository.getAllPaginated(0, state.pageSize);
      state = state.copyWith(
        festivals: initialFestivals,
        page: 1,
        isLoading: false,
        hasReachedMax: initialFestivals.length < state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchPaginatedFestival() async {
    if (state.isLoading || state.hasReachedMax) return;

    try {
      state = state.copyWith(isLoading: true);

      final newFestivals =
          await repository.getAllPaginated(state.page, state.pageSize);

      final hasReachedMax = newFestivals.length < state.pageSize;

      state = state.copyWith(
        festivals: [...state.festivals, ...newFestivals],
        page: state.page + 1,
        isLoading: false,
        hasReachedMax: hasReachedMax,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Festival?> fetchFestivalBySlug(String slug) async {
    return await repository.getBySlug(slug);
  }

  Future<void> searchFestivals(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await repository.searchFestivalByTitleAndContent(query);
      state = state.copyWith(
        festivals: results,
        isLoading: false,
        hasReachedMax: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // to get the total number of festivals
  Future<int> getFestivalCount() async {
    final totalFestivals = await repository.getCount();
    return totalFestivals;
  }

  void clearSearchResults() {
    state = FestivalListState.initial();
  }
}

class FestivalListState {
  final List<Festival> festivals;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final int pageSize;
  final String? error;

  FestivalListState({
    required this.festivals,
    required this.isLoading,
    required this.hasReachedMax,
    required this.page,
    required this.pageSize,
    this.error,
  });

  factory FestivalListState.initial() {
    return FestivalListState(
      festivals: [],
      isLoading: false,
      hasReachedMax: false,
      page: 0,
      pageSize: 20,
    );
  }

  FestivalListState copyWith({
    List<Festival>? festivals,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    int? pageSize,
    String? error,
  }) {
    return FestivalListState(
      festivals: festivals ?? this.festivals,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
    );
  }
}

// Providers remain the same
final festivalRepositoryProvider = Provider<DatabaseRepository<Festival>>(
  (ref) {
    final dbHelper = ref.read(databaseHelperProvider);
    return DatabaseRepository<Festival>(
      dbHelper: dbHelper,
      tableName: 'events',
      fromMap: Festival.fromMap,
      toMap: (festival) => festival.toMap(),
    );
  },
);

final festivalNotifierProvider =
    StateNotifierProvider<FestivalNotifier, FestivalListState>(
  (ref) {
    final repository = ref.read(festivalRepositoryProvider);
    return FestivalNotifier(repository);
  },
);

final selectedFestivalProvider = StateProvider<Festival?>((ref) => null);
