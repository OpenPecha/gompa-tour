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

  Future<T?> getById(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? fromMap(maps.first) : null;
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
