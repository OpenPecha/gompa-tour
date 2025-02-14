import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/models/gonpa.dart';
import 'package:gompa_tour/repo/api_repository.dart';

class GonpaListState {
  final List<Gonpa> gonpas;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final int pageSize;
  final String? error;

  GonpaListState({
    required this.gonpas,
    required this.isLoading,
    required this.hasReachedMax,
    required this.page,
    required this.pageSize,
    this.error,
  });

  factory GonpaListState.initial() {
    return GonpaListState(
      gonpas: [],
      isLoading: false,
      hasReachedMax: false,
      page: 0,
      pageSize: 20,
    );
  }

  GonpaListState copyWith({
    List<Gonpa>? gonpas,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    int? pageSize,
    String? error,
  }) {
    return GonpaListState(
      gonpas: gonpas ?? this.gonpas,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
    );
  }
}

class GonpaNotifier extends StateNotifier<GonpaListState> {
  final ApiRepository<Gonpa> apiRepository;

  GonpaNotifier(this.apiRepository) : super(GonpaListState.initial());

  Future<void> fetchInitialGonpas() async {
    state = state.copyWith(isLoading: true);
    try {
      final initialGonpas =
          await apiRepository.getAllPaginated(0, state.pageSize);
      state = state.copyWith(
        gonpas: initialGonpas,
        isLoading: false,
        hasReachedMax: initialGonpas.length < state.pageSize,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchMoreGonpas() async {
    if (state.isLoading || state.hasReachedMax) return;
    try {
      final gonpas =
          await apiRepository.getAllPaginated(state.page, state.pageSize);
      state = state.copyWith(
        gonpas: List.of(state.gonpas)..addAll(gonpas),
        isLoading: false,
        hasReachedMax: gonpas.length < state.pageSize,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Fetch initial gonpa based on category
  Future<void> fetchInitialGonpasByCategory(String category) async {
    state = state.copyWith(isLoading: true);
    try {
      final initialGonpas = await apiRepository.getAllPaginatedByCategory(
          0, state.pageSize, category);
      state = state.copyWith(
        gonpas: initialGonpas,
        isLoading: false,
        hasReachedMax: initialGonpas.length < state.pageSize,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Fetch paginated gonpa based on category
  Future<void> fetchMoreGonpasByCategory(String category) async {
    if (state.isLoading || state.hasReachedMax) return;
    try {
      final gonpas = await apiRepository.getAllPaginatedByCategory(
          state.page, state.pageSize, category);
      state = state.copyWith(
        gonpas: List.of(state.gonpas)..addAll(gonpas),
        isLoading: false,
        hasReachedMax: gonpas.length < state.pageSize,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Fetch all gonpa
  Future<List<Gonpa>> fetchAllGonpas() async {
    try {
      final gonpas = await apiRepository.getAll();
      return gonpas;
    } catch (e) {
      return [];
    }
  }

  // search all gonpa
  Future<void> searchGonpas(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final gonpas = await apiRepository.searchByTitleAndContent(query);
      state = state.copyWith(
        gonpas: gonpas.where((gonpa) {
          return gonpa.translations.any((translation) {
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
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // search gonpa based on category
  Future<void> searchGonpasByCategory(String query, String category) async {
    state = state.copyWith(isLoading: true);
    try {
      final gonpas = await apiRepository.searchByTitleAndContentAndCategory(
          query, category);
      state = state.copyWith(
        gonpas: gonpas
            .where((gonpa) => gonpa.translations.any((translation) =>
                (translation.name
                    .toLowerCase()
                    .contains(query.toLowerCase())) ||
                (translation.description
                    .toLowerCase()
                    .contains(query.toLowerCase()))))
            .toList(),
        isLoading: false,
        hasReachedMax: true,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // total number of gonpa
  Future<int> getTotalGonpas() async {
    try {
      final gonpas = await apiRepository.getAll();
      return gonpas.length;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return 0;
    }
  }

  void clearSearchResults() {
    state = GonpaListState.initial();
  }
}

final gonpaRepositoryProvider = Provider<ApiRepository<Gonpa>>((ref) {
  return ApiRepository<Gonpa>(
    baseUrl: dotenv.env['BASE_URL']!,
    endpoint: "gonpa",
    fromJson: (json) => Gonpa.fromJson(json),
    toJson: (gonpa) => gonpa.toJson(),
  );
});

final gonpaNotifierProvider =
    StateNotifierProvider<GonpaNotifier, GonpaListState>(
  (ref) => GonpaNotifier(ref.watch(gonpaRepositoryProvider)),
);

final selectedGonpaProvider = StateProvider<Gonpa?>((ref) => null);
