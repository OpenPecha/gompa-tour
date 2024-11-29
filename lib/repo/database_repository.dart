import 'package:gompa_tour/models/festival_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';
import '../models/deity_model.dart';
import '../models/organization_model.dart';

class DatabaseRepository<T> {
  final DatabaseHelper dbHelper;
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;
  final Map<String, dynamic> Function(T) toMap;

  DatabaseRepository({
    required this.dbHelper,
    required this.tableName,
    required this.fromMap,
    required this.toMap,
  });

  Future<List<T>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.query(tableName);
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<List<T>> getAllPaginated(int page, int pageSize) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      tableName,
      limit: pageSize,
      offset: page * pageSize,
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<T?> getBySlug(String slug) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      tableName,
      where: 'slug = ?',
      whereArgs: [slug],
    );
    if (maps.isNotEmpty) {
      return fromMap(maps.first);
    }
    return null;
  }

  Future<T?> getById(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? fromMap(maps.first) : null;
  }

  Future<List<T>> searchByTitleAndContent(String query) async {
    final db = await dbHelper.database;
    final escapedQuery = query.replaceAll("'", "''");

    final rawQuery = '''
    SELECT *, 
    CASE 
      WHEN LOWER(enTitle) LIKE LOWER('%$escapedQuery%') THEN 1
      WHEN LOWER(enContent) LIKE LOWER('%$escapedQuery%') THEN 2
      ELSE 3
    END AS match_priority
    FROM $tableName
    WHERE 
      LOWER(enTitle) LIKE LOWER('%$escapedQuery%') OR 
      LOWER(enContent) LIKE LOWER('%$escapedQuery%')
    ORDER BY match_priority ASC
  ''';

    final maps = await db.rawQuery(rawQuery);
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<int> insert(T item) async {
    final db = await dbHelper.database;
    return await db.insert(
      tableName,
      toMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(T item) async {
    final db = await dbHelper.database;
    return await db.update(
      tableName,
      toMap(item),
      where: 'id = ?',
      whereArgs: [toMap(item)['id']],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<T>> getSortedPaginatedOrganization(int page, int pageSize) async {
    final db = await dbHelper.database;
    final rawQuery = '''
    SELECT organization.* FROM categories 
    JOIN organization ON categories.title = organization.categories 
    ORDER BY code ASC
    LIMIT ? OFFSET ?
  ''';

    final maps = await db.rawQuery(rawQuery, [pageSize, page * pageSize]);

    return maps.map((map) => fromMap(map)).toList();
  }
}

class SearchRepository {
  final DatabaseHelper dbHelper;
  SearchRepository({
    required this.dbHelper,
  });
  Future<List<dynamic>> searchAcrossTables(String query) async {
    final escapedQuery = query.replaceAll("'", "''");

    // Query organizations with score
    final organizationQuery = '''
    SELECT *, 
    CASE 
      WHEN LOWER(enTitle) LIKE LOWER('%$escapedQuery%') THEN 1
      WHEN LOWER(enContent) LIKE LOWER('%$escapedQuery%') THEN 2
      ELSE 3 
    END as match_score
    FROM organization 
    WHERE LOWER(enTitle) LIKE LOWER('%$escapedQuery%') 
    OR LOWER(enContent) LIKE LOWER('%$escapedQuery%')
  ''';

    // Query deities with score
    final deityQuery = '''
    SELECT *, 
    CASE 
      WHEN LOWER(enTitle) LIKE LOWER('%$escapedQuery%') THEN 1
      WHEN LOWER(enContent) LIKE LOWER('%$escapedQuery%') THEN 2
      ELSE 3 
    END as match_score
    FROM tensum 
    WHERE LOWER(enTitle) LIKE LOWER('%$escapedQuery%') 
    OR LOWER(enContent) LIKE LOWER('%$escapedQuery%')
  ''';

    // Query festivals with score
    final festivalQuery = '''
    SELECT *,
    CASE
      WHEN LOWER(enTitle) LIKE LOWER('%$escapedQuery%') THEN 1
      WHEN LOWER(enContent) LIKE LOWER('%$escapedQuery%') THEN 2
      ELSE 3
    END as match_score 
    FROM events
    WHERE LOWER(enTitle) LIKE LOWER('%$escapedQuery%')
    OR LOWER(enContent) LIKE LOWER('%$escapedQuery%')
  ''';

    final db = await dbHelper.database;

    final organizationMaps = await db.rawQuery(organizationQuery);
    final deityMaps = await db.rawQuery(deityQuery);
    final festivalMaps = await db.rawQuery(festivalQuery);

    // Convert to models while preserving scores
    final organizations = organizationMaps.map((map) {
      final score = map['match_score'] as int;
      final mapWithoutScore = Map<String, dynamic>.from(map)
        ..remove('match_score');
      return (Organization.fromMap(mapWithoutScore), score);
    }).toList();

    final deities = deityMaps.map((map) {
      final score = map['match_score'] as int;
      final mapWithoutScore = Map<String, dynamic>.from(map)
        ..remove('match_score');
      return (Deity.fromMap(mapWithoutScore), score);
    }).toList();

    final festivals = festivalMaps.map((map) {
      final score = map['match_score'] as int;
      final mapWithoutScore = Map<String, dynamic>.from(map)
        ..remove('match_score');
      return (Festival.fromMap(mapWithoutScore), score);
    }).toList();

    // Combine and sort by score
    final combinedResults = [...organizations, ...deities, ...festivals];
    combinedResults.sort((a, b) => a.$2.compareTo(b.$2)); // Sort by score

    // Return just the models in sorted order
    return combinedResults.map((tuple) => tuple.$1).toList();
  }
}
