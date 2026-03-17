// lib/screens/word_detail_screen.dart
// Full-screen detail view for a single word with large image, audio, and example.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/word.dart';
import '../services/dictionary_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/word_image.dart';
import '../widgets/audio_button.dart';

class WordDetailScreen extends StatefulWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  late Word _word;

  @override
  void initState() {
    super.initState();
    _word = widget.word;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DictionaryProvider>();
    final color = AppTheme.categoryColor(_word.category);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.surface,
            iconTheme: const IconThemeData(color: AppTheme.textPrimary),
            actions: [
              // Favorite toggle in app bar
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _word.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    key: ValueKey(_word.isFavorite),
                    color: _word.isFavorite
                        ? AppTheme.secondary
                        : AppTheme.textSecondary,
                  ),
                ),
                onPressed: () async {
                  await provider.toggleFavorite(_word);
                  // Refresh local state from DB
                  final updated = await provider.getWord(_word.id!);
                  if (updated != null && mounted) {
                    setState(() => _word = updated);
                  }
                },
              ),
            ],
          ),

          // ── Hero image ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: WordImage(
                  imagePath: _word.image,
                  category: _word.category,
                  size: 200,
                ),
              ),
            ),
          ),

          // ── Word card ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── French label ───────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🇫🇷 Français',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _word.french,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.border),
                  const SizedBox(height: 16),

                  // ── English translation ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '🇬🇧 English',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _word.english,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: color,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // ── Audio button ───────────────────────────────────────
                  Center(
                    child: AudioButton(
                      audioPath: _word.audio,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Example sentence card ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_quote_rounded, color: color, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Example',
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _word.example,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // ── Category chip ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border:
                          Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${_categoryEmoji(_word.category)}  ${_word.category[0].toUpperCase()}${_word.category.substring(1)}',
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryEmoji(String category) {
    const map = {
      'animals': '🐾',
      'food': '🍎',
      'house': '🏠',
      'school': '📚',
      'transport': '🚗',
      'nature': '🌿',
    };
    return map[category] ?? '📖';
  }
}
