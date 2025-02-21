import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/config/constant.dart';
import 'package:gompa_tour/helper/database_helper.dart';
import 'package:gompa_tour/models/pilgrim_site.dart';
import 'package:gompa_tour/repo/api_repository.dart';

class PilgrimSiteState {
  final List<PilgrimSite> pilgrimSites;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final int pageSize;
  final String? error;

  PilgrimSiteState({
    required this.pilgrimSites,
    required this.isLoading,
    required this.hasReachedMax,
    required this.page,
    required this.pageSize,
    this.error,
  });

  factory PilgrimSiteState.initial() {
    return PilgrimSiteState(
      pilgrimSites: [],
      isLoading: false,
      hasReachedMax: false,
      page: 0,
      pageSize: 20,
    );
  }

  PilgrimSiteState copyWith({
    List<PilgrimSite>? pilgrimSites,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    int? pageSize,
    String? error,
  }) {
    return PilgrimSiteState(
      pilgrimSites: pilgrimSites ?? this.pilgrimSites,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
    );
  }
}

class PilgrimSiteNotifier extends StateNotifier<PilgrimSiteState> {
  final ApiRepository<PilgrimSite> apiRepository;

  PilgrimSiteNotifier(this.apiRepository) : super(PilgrimSiteState.initial());

  // Fetch initial pilgrimSites
  Future<void> fetchInitialPilgrimSites() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final pilgrimSites = await apiRepository.getAllPaginated(
        0,
        state.pageSize,
      );
      state = state.copyWith(
        pilgrimSites: pilgrimSites,
        isLoading: false,
        hasReachedMax: pilgrimSites.length < state.pageSize,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Fetch more pilgrimSites
  Future<void> fetchMorePilgrimSites() async {
    if (state.isLoading || state.hasReachedMax) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newpilgrimSites =
          await apiRepository.getAllPaginated(state.page, state.pageSize);
      final hasReachedMax = newpilgrimSites.length < state.pageSize;

      state = state.copyWith(
        pilgrimSites: [...state.pilgrimSites, ...newpilgrimSites],
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

  // search pilgrimSites
  Future<void> searchPilgrimSites(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await apiRepository.searchByTitleAndContent(query);
      state = state.copyWith(
        pilgrimSites: results.where((pilgrimSite) {
          return pilgrimSite.translations.any((translation) {
            return (translation.name
                .toLowerCase()
                .contains(query.toLowerCase()));
          });
        }).toList(),
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

  // get all the pilgrimSites
  Future<List<PilgrimSite>> fetchAllPilgrimSites() async {
    try {
      final allPilgrimSites = await apiRepository.getAll();
      return allPilgrimSites;
    } catch (e) {
      return [];
    }
  }

  // get total number of pilgrimSites
  Future<int> getTotalPilgrimSites() async {
    final totalPilgrimSites = await apiRepository.getTotalData();
    return totalPilgrimSites;
  }

  // filter pilgrimSites by state
  Future<void> filterPilgrimSites(String stateFilter) async {
    state = state.copyWith(isLoading: true);
    try {
      final pilgrimSites = await apiRepository.getAll();
      final filteredPilgrimSites = pilgrimSites
          .where((pilgrimSite) =>
              pilgrimSite.contact?.translations.any((translation) => translation
                  .state
                  .toLowerCase()
                  .contains(stateFilter.toLowerCase())) ??
              false)
          .toList();
      state = state.copyWith(
        pilgrimSites: filteredPilgrimSites,
        isLoading: false,
        hasReachedMax: true,
        page: 1,
      );
    } catch (e) {
      logger.severe('Failed to filter PilgrimSite: $e');
    }
  }

  // list out all the unique states of the pilgrimSites
  Future<List<String?>> getUniqueStates() async {
    try {
      final pilgrimSites = await apiRepository.getAll();
      final sites = pilgrimSites
          .expand((sites) =>
              sites.contact?.translations
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
      return sites.cast<String?>();
    } catch (e) {
      logger.severe('Failed to get unique states: $e');
      return [];
    }
  }

  void clearSearchResults() {
    state = PilgrimSiteState.initial();
  }
}

// pilgrimSites provider
final pilgrimSiteRepositoryProvider = Provider<ApiRepository<PilgrimSite>>(
  (ref) => ApiRepository<PilgrimSite>(
    baseUrl: kBaseAPIUrl,
    endpoint: 'pilgrim',
    fromJson: PilgrimSite.fromJson,
    toJson: (pillgrimSite) => pillgrimSite.toJson(),
  ),
);

final pilgrimSiteNotifierProvider =
    StateNotifierProvider<PilgrimSiteNotifier, PilgrimSiteState>(
  (ref) {
    final repository = ref.watch(pilgrimSiteRepositoryProvider);
    return PilgrimSiteNotifier(repository);
  },
);

final selectedPilgrimSiteProvider = StateProvider<PilgrimSite?>((ref) => null);
