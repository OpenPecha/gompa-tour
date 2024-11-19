import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/organization_model.dart';
import '../repo/database_repository.dart';
import 'database_state.dart';

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
    StateNotifierProvider<OrganizationNotifier, List<Organization>>((ref) {
  final repository = ref.read(organizationRepositoryProvider);
  return OrganizationNotifier(repository);
});

class OrganizationNotifier extends StateNotifier<List<Organization>> {
  final DatabaseRepository<Organization> repository;

  OrganizationNotifier(this.repository) : super([]);

  Future<void> fetchOrganizations() async {
    state = await repository.getAll();
  }
}

final selectedOrganizationProvider =
    StateProvider<Organization?>((ref) => null);
