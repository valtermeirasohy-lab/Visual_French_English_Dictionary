// lib/services/dictionary_provider.dart
// Central state manager using ChangeNotifier + Provider.
// Holds words, favorites, search results, and loading states.

import 'package:flutter/foundation.dart';
import '../models/word.dart';
import 'database_service.dart';

class DictionaryProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  // ── State ──────────────────────────────────────────────────────────────────
  List<Word> _categoryWords = [];
  List<Word> _favorites = [];
  List<Word> _searchResults = [];
  Map<String, int> _categoryCounts = {};
  bool _isLoading = false;
  String _searchQuery = '';

  // ── Getters ────────────────────────────────────────────────────────────────
  List<Word> get categoryWords => _categoryWords;
  List<Word> get favorites => _favorites;
  List<Word> get searchResults => _searchResults;
  Map<String, int> get categoryCounts => _categoryCounts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // ── Initialization ─────────────────────────────────────────────────────────

  /// Load category counts for home screen badges
  Future<void> loadCategoryCounts() async {
    _categoryCounts = await _db.getCategoryCounts();
    notifyListeners();
  }

  // ── Category Words ─────────────────────────────────────────────────────────

  /// Load all words for a given category
  Future<void> loadCategory(String categoryId) async {
    _isLoading = true;
    notifyListeners();
    _categoryWords = await _db.getWordsByCategory(categoryId);
    _isLoading = false;
    notifyListeners();
  }

  // ── Favorites ──────────────────────────────────────────────────────────────

  /// Refresh the favorites list from the database
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    _favorites = await _db.getFavorites();
    _isLoading = false;
    notifyListeners();
  }

  /// Toggle a word's favorite status and refresh both lists
  Future<void> toggleFavorite(Word word) async {
    if (word.id == null) return;
    final newValue = !word.isFavorite;
    await _db.toggleFavorite(word.id!, newValue);

    // Update in categoryWords list
    _categoryWords = _categoryWords.map((w) {
      return w.id == word.id ? w.copyWith(isFavorite: newValue) : w;
    }).toList();

    // Update in searchResults list
    _searchResults = _searchResults.map((w) {
      return w.id == word.id ? w.copyWith(isFavorite: newValue) : w;
    }).toList();

    // Refresh favorites list
    await loadFavorites();
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  /// Search words by French or English text
  Future<void> search(String query) async {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    _searchResults = await _db.searchWords(query);
    _isLoading = false;
    notifyListeners();
  }

  /// Clear the search state
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  // ── Single Word ────────────────────────────────────────────────────────────

  /// Get a word and return the up-to-date version from the database
  Future<Word?> getWord(int id) => _db.getWordById(id);
}
