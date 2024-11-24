import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/deity_model.dart';
import '../repo/database_repository.dart';
import 'database_state.dart';

final deitiesRepositoryProvider = Provider<DatabaseRepository<Deity>>((ref) {
  final dbHelper = ref.read(databaseHelperProvider);
  return DatabaseRepository<Deity>(
    dbHelper: dbHelper,
    tableName: 'tensum',
    fromMap: Deity.fromMap,
    toMap: (org) => org.toMap(),
  );
});

final detiesNotifierProvider =
    StateNotifierProvider<DeityNotifier, List<Deity>>((ref) {
  final repository = ref.read(deitiesRepositoryProvider);
  return DeityNotifier(repository);
});

class DeityNotifier extends StateNotifier<List<Deity>> {
  final DatabaseRepository<Deity> repository;

  DeityNotifier(this.repository) : super([]);

  Future<void> fetchDeties(int page, int pageSize) async {
    final newDeties = await repository.getAllPaginated(page, pageSize);
    state = [...state, ...newDeties];
  }

  Future<Deity?> fetchDeityBySlug(String slug) async {
    return await repository.getBySlug(slug);
  }

  Future<void> searchDeities(String query) async {
    final results = await repository.searchByTitleAndContent(query);
    state = results;
  }

  void clearSearchResults() {
    state = [];
  }
}

final selectedDeityProvider = StateProvider<Deity?>((ref) => null);
