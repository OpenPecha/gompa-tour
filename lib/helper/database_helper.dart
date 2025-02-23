import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final Logger logger = Logger('DatabaseHelper');

class DatabaseInitializationException implements Exception {
  final String message;
  const DatabaseInitializationException(this.message);

  @override
  String toString() => 'DatabaseInitializationException: $message';
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init() {
    // Configure logging
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
    });
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('db/gonpa.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      logger.info('Attempting to initialize database at: $path');

      // Check if database already exists
      bool exists = await databaseExists(path);
      if (exists) {
        logger.info('Database already exists. Skipping copy from assets.');
        return await openDatabase(path, version: 1);
      }

      // Ensure directory exists
      final directory = Directory(dirname(path));
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        logger.info('Created database directory: ${directory.path}');
      }

      // Copy database from assets
      try {
        ByteData data = await rootBundle.load('assets/$filePath');
        final bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        await File(path).writeAsBytes(bytes, flush: true);
        logger.info('Successfully copied database from assets to: $path');
      } catch (e) {
        logger.severe('Failed to copy database from assets', e);
        throw DatabaseInitializationException(
            'Unable to copy database from assets: ${e.toString()}');
      }

      // Open the database
      return await openDatabase(path, version: 1);
    } catch (e) {
      logger.severe('Critical error in database initialization', e);
      throw DatabaseInitializationException(
          'Failed to initialize database: ${e.toString()}');
    }
  }

  // Optional: Method to verify database integrity
  Future<bool> verifyDatabaseIntegrity() async {
    try {
      final db = await database;
      // Example: Run a simple query to check database
      await db.rawQuery('SELECT * FROM organization');
      logger.info('Database integrity check passed');
      return true;
    } catch (e) {
      logger.severe('Database integrity check failed', e);
      return false;
    }
  }
}

// Usage in main.dart or initialization logic
Future<void> initializeDatabase() async {
  try {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database; // This triggers database initialization

    // Optional: Verify database after initialization
    final isIntact = await dbHelper.verifyDatabaseIntegrity();
    if (!isIntact) {
      // Handle database corruption scenario
      logger.info(
          'Database may be corrupted. Consider reinstalling or recovering.');
    }
  } on DatabaseInitializationException catch (e) {
    // Handle specific database initialization errors
    logger.severe('Database Initialization Error: $e');
    // Potentially show user-friendly error dialog
  } catch (e) {
    // Catch any unexpected errors
    logger.severe('Unexpected error during database initialization: $e');
  }
}
