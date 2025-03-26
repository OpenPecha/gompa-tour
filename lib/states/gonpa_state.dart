import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/config/constant.dart';
import 'package:gompa_tour/helper/database_helper.dart';
import 'package:gompa_tour/models/gonpa.dart';
import 'package:gompa_tour/repo/api_repository.dart';

class GonpaListState {
  final List<Gonpa> gonpas;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final int pageSize;
  final String? error;
  final List<String> types;

  GonpaListState({
    required this.gonpas,
    required this.isLoading,
    required this.hasReachedMax,
    required this.page,
    required this.pageSize,
    this.error,
    required this.types,
  });

  factory GonpaListState.initial() {
    return GonpaListState(
      gonpas: [],
      isLoading: false,
      hasReachedMax: false,
      page: 0,
      pageSize: 20,
      types: [],
    );
  }

  GonpaListState copyWith({
    List<Gonpa>? gonpas,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    int? pageSize,
    String? error,
    List<String>? types,
  }) {
    return GonpaListState(
      gonpas: gonpas ?? this.gonpas,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
      types: types ?? this.types,
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

  // Fetch initial gonpa based on sect
  Future<void> fetchInitialGonpasBySect(String sect) async {
    state = state.copyWith(isLoading: true);
    try {
      final initialGonpas =
          await apiRepository.getAllPaginatedBySect(0, state.pageSize, sect);
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

  // Fetch paginated gonpa based on sect
  Future<void> fetchMoreGonpasBySect(String sect) async {
    if (state.isLoading || state.hasReachedMax) return;
    try {
      final gonpas = await apiRepository.getAllPaginatedBySect(
          state.page, state.pageSize, sect);
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
    state = state.copyWith(isLoading: true);
    try {
      final gonpas = await apiRepository.getAll();
      state = state.copyWith(
        gonpas: gonpas,
        isLoading: false,
        hasReachedMax: true,
      );
      return gonpas;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return [];
    }
  }

  // fetch all gonpa types
  Future<void> fetchAllGonpaTypes() async {
    try {
      final gonpas = await apiRepository.getTypes();
      state = state.copyWith(types: gonpas);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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

  // search gonpa based on sect
  Future<void> searchGonpasBySect(String query, String sect) async {
    state = state.copyWith(isLoading: true);
    try {
      final gonpas = await apiRepository.filterBySect(sect);
      state = state.copyWith(
        gonpas: gonpas
            .where((gonpa) => gonpa.translations.any((translation) =>
                (translation.name.toLowerCase().contains(query.toLowerCase()))))
            .toList(),
        isLoading: false,
        hasReachedMax: true,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // get gonpa by id
  Future<Gonpa?> getGonpaById(String id) async {
    try {
      final gonpa = await apiRepository.getById(id);
      return gonpa;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
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

  // filte gonpa by type and sect
  Future<void> filterGonpas(
      {required String sect, String? type, String? stateFilter}) async {
    state = state.copyWith(isLoading: true);
    try {
      if (type != null && stateFilter != null) {
        final gonpas = await apiRepository.filterByTypeAndSect(type, sect);
        final filteredGonpas = gonpas
            .where((gonpa) =>
                gonpa.contact?.translations.any((translation) => translation
                    .state
                    .toLowerCase()
                    .contains(stateFilter.toLowerCase())) ??
                false)
            .toList();
        state = state.copyWith(
          gonpas: filteredGonpas,
          isLoading: false,
          hasReachedMax: true,
          page: 1,
        );
      } else if (type != null && stateFilter == null) {
        final gonpas = await apiRepository.filterByTypeAndSect(type, sect);
        state = state.copyWith(
          gonpas: gonpas,
          isLoading: false,
          hasReachedMax: true,
          page: 1,
        );
      } else if (type == null && stateFilter != null) {
        final gonpas = await apiRepository.filterBySect(sect);
        final filteredGonpas = gonpas
            .where((gonpa) =>
                gonpa.contact?.translations.any((translation) => translation
                    .state
                    .toLowerCase()
                    .contains(stateFilter.toLowerCase())) ??
                false)
            .toList();
        state = state.copyWith(
          gonpas: filteredGonpas,
          isLoading: false,
          hasReachedMax: true,
          page: 1,
        );
      } else {
        final gonpas = await apiRepository.filterBySect(sect);
        state = state.copyWith(
          gonpas: gonpas,
          isLoading: false,
          hasReachedMax: true,
          page: 1,
        );
      }
    } catch (e) {
      logger.severe('Failed to filter gonpas: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // list out all the unique states of gonpa data
  Future<List<String?>> getUniqueStates() async {
    try {
      final gonpas = await apiRepository.getAll();
      final states = gonpas
          .expand((gonpa) =>
              gonpa.contact?.translations
                  .map((translation) => translation.state.trim())
                  .where((state) => state.isNotEmpty) // Remove empty states
                  .map((state) => state
                      .replaceAll('(', '')
                      .replaceAll(')', '')
                      .replaceAll(',', '') // Remove all commas
                      .replaceAll(
                          '  ', ' ') // Replace double spaces with single space
                      .trim()) // Remove parentheses
              ??
              [])
          .toSet() // Get unique values
          .toList()
        ..sort();
      return states.cast<String?>();
    } catch (e) {
      logger.severe('Failed to get unique states: $e');
      return [];
    }
  }

  void clearSearchResults() {
    state = GonpaListState.initial();
  }
}

final gonpaRepositoryProvider = Provider<ApiRepository<Gonpa>>((ref) {
  return ApiRepository<Gonpa>(
    baseUrl: kBaseAPIUrl,
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
