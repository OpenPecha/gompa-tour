import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/deity_model.dart';
import '../repo/database_repository.dart';
import 'database_state.dart';

class DeityListState {
  final List<Deity> deities;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final int pageSize;
  final String? error;

  DeityListState({
    required this.deities,
    required this.isLoading,
    required this.hasReachedMax,
    required this.page,
    required this.pageSize,
    this.error,
  });

  factory DeityListState.initial() {
    return DeityListState(
      deities: [],
      isLoading: false,
      hasReachedMax: false,
      page: 0,
      pageSize: 20,
    );
  }

  DeityListState copyWith({
    List<Deity>? deities,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    int? pageSize,
    String? error,
  }) {
    return DeityListState(
      deities: deities ?? this.deities,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
    );
  }
}

class DeityNotifier extends StateNotifier<DeityListState> {
  final DatabaseRepository<Deity> repository;

  DeityNotifier(this.repository) : super(DeityListState.initial());

  Future<void> fetchInitialDeities() async {
    state = state.copyWith(isLoading: true);
    try {
      final initialDeities =
          await repository.getAllPaginated(0, state.pageSize);
      state = state.copyWith(
        deities: initialDeities,
        page: 1,
        isLoading: false,
        hasReachedMax: initialDeities.length < state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchPaginatedDeities() async {
    if (state.isLoading || state.hasReachedMax) return;

    try {
      state = state.copyWith(isLoading: true);

      final newDeities =
          await repository.getAllPaginated(state.page, state.pageSize);

      final hasReachedMax = newDeities.length < state.pageSize;

      state = state.copyWith(
        deities: [...state.deities, ...newDeities],
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

  Future<Deity?> fetchDeityBySlug(String slug) async {
    return await repository.getBySlug(slug);
  }

  Future<void> searchDeities(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await repository.searchByTitleAndContent(query);
      state = state.copyWith(
        deities: results,
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

  void clearSearchResults() {
    state = DeityListState.initial();
  }
}

// Providers
final deitiesRepositoryProvider = Provider<DatabaseRepository<Deity>>((ref) {
  final dbHelper = ref.read(databaseHelperProvider);
  return DatabaseRepository<Deity>(
    dbHelper: dbHelper,
    tableName: 'tensum',
    fromMap: Deity.fromMap,
    toMap: (deity) => deity.toMap(),
  );
});

final detiesNotifierProvider =
    StateNotifierProvider<DeityNotifier, DeityListState>((ref) {
  final repository = ref.read(deitiesRepositoryProvider);
  return DeityNotifier(repository);
});

final selectedDeityProvider = StateProvider<Deity?>((ref) => null);
