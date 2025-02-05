import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/models/pilgrimage_model.dart';
import 'package:gompa_tour/repo/database_repository.dart';
import 'package:gompa_tour/states/database_state.dart';

class PilgrimageListState {
  final List<Pilgrimage> pilgrimages;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final int pageSize;
  final String? error;

  PilgrimageListState({
    required this.pilgrimages,
    required this.isLoading,
    required this.hasReachedMax,
    required this.page,
    required this.pageSize,
    this.error,
  });

  factory PilgrimageListState.initial() {
    return PilgrimageListState(
      pilgrimages: [],
      isLoading: false,
      hasReachedMax: false,
      page: 0,
      pageSize: 20,
    );
  }

  PilgrimageListState copyWith({
    List<Pilgrimage>? pilgrimages,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    int? pageSize,
    String? error,
  }) {
    return PilgrimageListState(
      pilgrimages: pilgrimages ?? this.pilgrimages,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
    );
  }
}

class PilgrimageNotifier extends StateNotifier<PilgrimageListState> {
  final DatabaseRepository<Pilgrimage> repository;

  PilgrimageNotifier(this.repository) : super(PilgrimageListState.initial());

  // Fetch initial pilgrimages
  Future<void> fetchInitialPilgrimages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final pilgrimages = await repository.getAllPaginated(
        0,
        state.pageSize,
      );
      state = state.copyWith(
        pilgrimages: pilgrimages,
        isLoading: false,
        hasReachedMax: pilgrimages.length < state.pageSize,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Fetch more pilgrimages
  Future<void> fetchMorePilgrimages() async {
    if (state.isLoading || state.hasReachedMax) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newPilgrimages =
          await repository.getAllPaginated(state.page, state.pageSize);
      final hasReachedMax = newPilgrimages.length < state.pageSize;

      state = state.copyWith(
        pilgrimages: [...state.pilgrimages, ...newPilgrimages],
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

  // search pilgrimages
  Future<void> searchPilgrimages(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await repository.searchByTitleAndContent(query);
      state = state.copyWith(
        pilgrimages: results,
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

  // get total number of pilgrimages
  Future<int> getTotalPilgrimages() async {
    return await repository.getCount();
  }

  void clearSearchResults() {
    state = PilgrimageListState.initial();
  }
}

// pilgrimages provider
final pilgrimageRepositoryProvider = Provider<DatabaseRepository<Pilgrimage>>(
  (ref) {
    final dbHelper = ref.watch(databaseHelperProvider);
    return DatabaseRepository<Pilgrimage>(
      dbHelper: dbHelper,
      tableName: 'pilgrim',
      fromMap: (map) => Pilgrimage.fromMap(map),
      toMap: (pilgrimage) => pilgrimage.toMap(),
    );
  },
);

final pilgrimageNotifierProvider =
    StateNotifierProvider<PilgrimageNotifier, PilgrimageListState>(
  (ref) {
    final repository = ref.watch(pilgrimageRepositoryProvider);
    return PilgrimageNotifier(repository);
  },
);

final selectedPilgrimageProvider = StateProvider<Pilgrimage?>((ref) => null);
