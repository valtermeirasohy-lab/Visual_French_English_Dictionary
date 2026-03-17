// lib/screens/search_screen.dart
// Full-text search across all French and English words.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/dictionary_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/word_tile.dart';
import 'word_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DictionaryProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find words in French or English',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // ── Search bar ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchBarWidget(
                onChanged: (q) => provider.search(q),
                onClear: provider.clearSearch,
              ),
            ),

            const SizedBox(height: 16),

            // ── Results ───────────────────────────────────────────────────
            Expanded(
              child: _buildResults(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, DictionaryProvider provider) {
    // Empty state before any search
    if (provider.searchQuery.isEmpty) {
      return const _EmptyPrompt();
    }

    // Loading spinner
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // No results
    if (provider.searchResults.isEmpty) {
      return _NoResults(query: provider.searchQuery);
    }

    // Results list
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            '${provider.searchResults.length} result${provider.searchResults.length == 1 ? '' : 's'} for "${provider.searchQuery}"',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final word = provider.searchResults[index];
              return WordTile(
                word: word,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WordDetailScreen(word: word),
                  ),
                ),
                onFavoriteTap: () => provider.toggleFavorite(word),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Empty state widgets ───────────────────────────────────────────────────────

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🔍', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Type to search…',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try "chat", "dog", or "voiture"',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;
  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('😕', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different word',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
