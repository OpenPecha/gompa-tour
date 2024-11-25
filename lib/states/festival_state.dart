import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/models/festival_model.dart';
import 'package:gompa_tour/repo/database_repository.dart';
import 'package:gompa_tour/states/database_state.dart';

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
    StateNotifierProvider<FestivalNotifier, List<Festival>>(
  (ref) => FestivalNotifier(ref.read(festivalRepositoryProvider)),
);

class FestivalNotifier extends StateNotifier<List<Festival>> {
  final DatabaseRepository<Festival> repository;

  FestivalNotifier(this.repository) : super([]);

  Future<void> fetchFestivals(int page, int pageSize) async {
    final newFestivals = await repository.getAllPaginated(page, pageSize);
    state = [...state, ...newFestivals];
  }

  Future<Festival?> fetchFestivalBySlug(String slug) async {
    return await repository.getBySlug(slug);
  }

  Future<void> searchFestivals(String query) async {
    final results = await repository.searchByTitleAndContent(query);
    state = results;
  }

  void clearSearchResults() {
    state = [];
  }
}

final selectedFestivalProvider = StateProvider<Festival?>((ref) => null);
