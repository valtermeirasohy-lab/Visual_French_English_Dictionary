// lib/screens/word_list_screen.dart
// Shows a scrollable list of words for a given category.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../services/dictionary_provider.dart';
import '../widgets/word_tile.dart';
import 'word_detail_screen.dart';

class WordListScreen extends StatefulWidget {
  final Category category;

  const WordListScreen({super.key, required this.category});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  @override
  void initState() {
    super.initState();
    // Load words for this category when the screen first opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DictionaryProvider>().loadCategory(widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DictionaryProvider>();
    final color = Color(widget.category.color);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Colored header app bar ───────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: color,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.8), color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.category.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.category.nameFr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.category.name,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Word count badge ─────────────────────────────────────────────
          if (!provider.isLoading)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '${provider.categoryWords.length} words',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),

          // ── Loading / empty / list ────────────────────────────────────────
          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (provider.categoryWords.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No words in this category yet.')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final word = provider.categoryWords[index];
                  return WordTile(
                    word: word,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WordDetailScreen(word: word),
                      ),
                    ),
                    onFavoriteTap: () =>
                        provider.toggleFavorite(word),
                  );
                },
                childCount: provider.categoryWords.length,
              ),
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}
