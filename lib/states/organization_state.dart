import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/organization_model.dart';
import '../repo/database_repository.dart';
import 'database_state.dart';
import 'package:sqflite/sqflite.dart';

class OrganizationListState {
  final List<Organization> organizations;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final int pageSize;
  final String? error;

  OrganizationListState({
    required this.organizations,
    required this.isLoading,
    required this.hasReachedMax,
    required this.page,
    required this.pageSize,
    this.error,
  });

  factory OrganizationListState.initial() {
    return OrganizationListState(
      organizations: [],
      isLoading: false,
      hasReachedMax: false,
      page: 0,
      pageSize: 20,
    );
  }

  OrganizationListState copyWith({
    List<Organization>? organizations,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    int? pageSize,
    String? error,
  }) {
    return OrganizationListState(
      organizations: organizations ?? this.organizations,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      error: error ?? this.error,
    );
  }
}

class OrganizationNotifier extends StateNotifier<OrganizationListState> {
  final DatabaseRepository<Organization> repository;

  OrganizationNotifier(this.repository)
      : super(OrganizationListState.initial());

  // Fetch initial organizations
  Future<void> fetchInitialOrganizations() async {
    state = state.copyWith(isLoading: true);
    try {
      final initialOrganizations =
          await repository.getAllPaginated(0, state.pageSize);
      state = state.copyWith(
        organizations: initialOrganizations,
        page: 1,
        isLoading: false,
        hasReachedMax: initialOrganizations.length < state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // fetch paginated organizations
  Future<void> fetchPaginatedOrganizations() async {
    if (state.isLoading || state.hasReachedMax) return;

    try {
      state = state.copyWith(isLoading: true);

      final newOrganizations =
          await repository.getAllPaginated(state.page, state.pageSize);

      final hasReachedMax = newOrganizations.length < state.pageSize;

      state = state.copyWith(
        organizations: [...state.organizations, ...newOrganizations],
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

  // Fetch initial organizations based on category
  Future<void> fetchCategorisedInitialOrganizations(
      List<String> category) async {
    state = state.copyWith(isLoading: true);
    try {
      final initialOrganizations = await repository
          .getSortedPaginatedOrganization(0, state.pageSize, category);
      state = state.copyWith(
        organizations: initialOrganizations,
        page: 1,
        isLoading: false,
        hasReachedMax: initialOrganizations.length < state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Fetch all organizations
  Future<void> fetchOrganizations() async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await repository.getAll();
      state = state.copyWith(
        organizations: results,
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

  // Fetch paginated organizations based on category
  Future<void> fetchPaginatedCategorisedOrganizations(
      List<String> category) async {
    if (state.isLoading || state.hasReachedMax) return;

    try {
      state = state.copyWith(isLoading: true);

      final newOrganizations = await repository.getSortedPaginatedOrganization(
          state.page, state.pageSize, category);

      final hasReachedMax = newOrganizations.length < state.pageSize;

      state = state.copyWith(
        organizations: [...state.organizations, ...newOrganizations],
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

  // Fetch organization by slug
  Future<Organization?> fetchOrganizationBySlug(String slug) async {
    return await repository.getBySlug(slug);
  }

  Future<void> searchOrganizations(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await repository.searchByTitleAndContent(query);
      state = state.copyWith(
        organizations: results,
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

  // search organizations based on category
  Future<void> searchOrganizationsByCategory(
      String query, List<String> category) async {
    state = state.copyWith(isLoading: true);
    try {
      final results =
          await repository.searchByTitleAndContentAndCategory(query, category);
      state = state.copyWith(
        organizations: results,
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

  // get total number of organizations
  Future<int> getOrganizationCount() async {
    return await repository.getCount();
  }

  // get total number of organizations based on category
  Future<List<Map<String, dynamic>>> getOrganizationCountByCategory() async {
    final db = await repository.dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT categories, COUNT(*) as count 
    FROM organization 
    GROUP BY categories
  ''');

    return maps;
  }

  void clearSearchResults() {
    state = OrganizationListState.initial();
  }
}

// Providers
final organizationRepositoryProvider =
    Provider<DatabaseRepository<Organization>>((ref) {
  final dbHelper = ref.read(databaseHelperProvider);
  return DatabaseRepository<Organization>(
    dbHelper: dbHelper,
    tableName: 'organization',
    fromMap: Organization.fromMap,
    toMap: (org) => org.toMap(),
  );
});

final organizationNotifierProvider =
    StateNotifierProvider<OrganizationNotifier, OrganizationListState>((ref) {
  final repository = ref.read(organizationRepositoryProvider);
  return OrganizationNotifier(repository);
});

final selectedOrganizationProvider =
    StateProvider<Organization?>((ref) => null);
