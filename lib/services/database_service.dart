// lib/services/database_service.dart
// Handles all SQLite operations: initialization, CRUD, search, and favorites.

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/word.dart';
import 'seed_data.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  // Lazily initialize the database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'french_dict.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create table and seed with initial 50-word dataset
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        french TEXT NOT NULL,
        english TEXT NOT NULL,
        image TEXT NOT NULL,
        audio TEXT NOT NULL,
        example TEXT NOT NULL,
        category TEXT NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Insert all seed words in a batch for performance
    final batch = db.batch();
    for (final word in kSeedWords) {
      batch.insert('words', word.toMap());
    }
    await batch.commit(noResult: true);
  }

  // ─── Read Operations ────────────────────────────────────────────────────────

  /// Fetch all words in a given category
  Future<List<Word>> getWordsByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      'words',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'french ASC',
    );
    return maps.map(Word.fromMap).toList();
  }

  /// Fetch all favorited words
  Future<List<Word>> getFavorites() async {
    final db = await database;
    final maps = await db.query(
      'words',
      where: 'is_favorite = 1',
      orderBy: 'french ASC',
    );
    return maps.map(Word.fromMap).toList();
  }

  /// Search words by French or English text (case-insensitive)
  Future<List<Word>> searchWords(String query) async {
    if (query.trim().isEmpty) return [];
    final db = await database;
    final q = '%${query.toLowerCase()}%';
    final maps = await db.query(
      'words',
      where: 'LOWER(french) LIKE ? OR LOWER(english) LIKE ?',
      whereArgs: [q, q],
      orderBy: 'french ASC',
    );
    return maps.map(Word.fromMap).toList();
  }

  /// Get a single word by id
  Future<Word?> getWordById(int id) async {
    final db = await database;
    final maps = await db.query('words', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Word.fromMap(maps.first);
  }

  // ─── Write Operations ────────────────────────────────────────────────────────

  /// Toggle the favorite status of a word
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    await db.update(
      'words',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get word count per category (useful for category cards)
  Future<Map<String, int>> getCategoryCounts() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT category, COUNT(*) as count FROM words GROUP BY category',
    );
    return {for (final row in result) row['category'] as String: row['count'] as int};
  }

  /// Close the database (call on app dispose)
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
