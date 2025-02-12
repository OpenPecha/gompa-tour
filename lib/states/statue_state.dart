// lib/states/Statue_state.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/helper/database_helper.dart';
import 'package:gompa_tour/models/statue.dart';
import 'package:gompa_tour/repo/api_repository.dart';

class StatueListState {
  final List<Statue> statues;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final int pageSize;
  final String? error;

  StatueListState({
    required this.statues,
    required this.isLoading,
    required this.hasReachedMax,
    required this.page,
    required this.pageSize,
    this.error,
  });

  factory StatueListState.initial() {
    return StatueListState(
      statues: [],
      isLoading: false,
      hasReachedMax: false,
      page: 0,
      pageSize: 20,
    );
  }

  StatueListState copyWith({
    List<Statue>? statues,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    int? pageSize,
    String? error,
  }) {
    return StatueListState(
      statues: statues ?? this.statues,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
    );
  }
}

class StatueNotifier extends StateNotifier<StatueListState> {
  final ApiRepository<Statue> repository;

  StatueNotifier(this.repository) : super(StatueListState.initial());

  Future<void> fetchInitialStatues() async {
    state = state.copyWith(isLoading: true);
    try {
      final initialStatues =
          await repository.getAllPaginated(0, state.pageSize);
      state = state.copyWith(
        statues: initialStatues,
        page: 1,
        isLoading: false,
        hasReachedMax: initialStatues.length < state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchMoreStatues() async {
    if (state.isLoading || state.hasReachedMax) return;

    state = state.copyWith(isLoading: true);
    try {
      final moreStatues =
          await repository.getAllPaginated(state.page, state.pageSize);

      final hasReachedMax = moreStatues.length < state.pageSize;

      state = state.copyWith(
          statues: [...state.statues, ...moreStatues],
          page: state.page + 1,
          isLoading: false,
          hasReachedMax: hasReachedMax);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // search status by title and content
  Future<void> searchStatues(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final searchResults = await repository.searchByTitleAndContent(query);
      state = state.copyWith(
        statues: searchResults.where((statue) {
          return statue.translations.any((translation) {
            return (translation.name
                    .toLowerCase()
                    .contains(query.toLowerCase())) ||
                (translation.description
                    .toLowerCase()
                    .contains(query.toLowerCase()));
          });
        }).toList(),
        isLoading: false,
        hasReachedMax: true,
      );
    } catch (e) {
      logger.severe('Error filtering statues: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // get total number of statues
  Future<int> getTotalStatues() async {
    final totalStatues = await repository.getTotalData();
    return totalStatues;
  }

  // clear search results
  void clearSearchResults() {
    state = StatueListState.initial();
  }
}

final StatueApiRepositoryProvider = Provider<ApiRepository<Statue>>(
  (ref) => ApiRepository<Statue>(
    baseUrl: dotenv.env["BASE_URL"]!,
    endpoint: 'statue',
    fromJson: Statue.fromJson,
    toJson: (Statue) => Statue.toJson(),
  ),
);

final statueNotifierProvider =
    StateNotifierProvider<StatueNotifier, StatueListState>(
  (ref) {
    final repository = ref.watch(StatueApiRepositoryProvider);
    return StatueNotifier(repository);
  },
);

final selectedStatueProvider = StateProvider<Statue?>((ref) => null);
