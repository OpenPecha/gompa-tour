import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/models/festival.dart';
import 'package:gompa_tour/repo/api_repository.dart';

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

class FestivalNotifier extends StateNotifier<FestivalListState> {
  final ApiRepository<Festival> apiRepository;

  FestivalNotifier(this.apiRepository) : super(FestivalListState.initial());

  Future<void> fetchInitialFestivals() async {
    state = state.copyWith(isLoading: true);
    try {
      final initialFestivals =
          await apiRepository.getAllPaginated(0, state.pageSize);
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
          await apiRepository.getAllPaginated(state.page, state.pageSize);

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

  Future<void> searchFestivals(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await apiRepository.searchByTitleAndContent(query);
      state = state.copyWith(
        festivals: results.where((festival) {
          return festival.translations.any((translation) {
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
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // get all the festivals
  Future<List<Festival>> fetchAllFestivals() async {
    try {
      final allFestivals = await apiRepository.getAll();
      return allFestivals;
    } catch (e) {
      return [];
    }
  }

  // to get the total number of festivals
  Future<int> getFestivalCount() async {
    final totalFestivals = await apiRepository.getTotalData();
    return totalFestivals;
  }

  void clearSearchResults() {
    state = FestivalListState.initial();
  }

  // get festival by id
  Future<Festival?> fetchFestivalById(String id) async {
    try {
      final festival = await apiRepository.getById(id);
      return festival;
    } catch (e) {
      return null;
    }
  }
}

// Providers remain the same
final festivalRepositoryProvider = Provider<ApiRepository<Festival>>(
  (ref) => ApiRepository<Festival>(
    baseUrl: dotenv.env["BASE_URL"]!,
    endpoint: 'festival',
    fromJson: (json) => Festival.fromJson(json),
    toJson: (festival) => festival.toJson(),
  ),
);

final festivalNotifierProvider =
    StateNotifierProvider<FestivalNotifier, FestivalListState>(
  (ref) {
    final repository = ref.read(festivalRepositoryProvider);
    return FestivalNotifier(repository);
  },
);

final selectedFestivalProvider = StateProvider<Festival?>((ref) => null);
