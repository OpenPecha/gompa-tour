import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

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
}
