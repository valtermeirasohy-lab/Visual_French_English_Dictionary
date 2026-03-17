// lib/widgets/word_tile.dart
// A single row in the word list screen showing image, French, and English word.

import 'package:flutter/material.dart';
import '../models/word.dart';
import '../utils/app_theme.dart';
import 'word_image.dart';

class WordTile extends StatelessWidget {
  final Word word;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const WordTile({
    super.key,
    required this.word,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Small category-colored image thumbnail
            WordImage(imagePath: word.image, category: word.category, size: 56),

            const SizedBox(width: 14),

            // French and English labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.french,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    word.english,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.categoryColor(word.category),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),

            // Favorite heart button
            GestureDetector(
              onTap: onFavoriteTap,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  word.isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(word.isFavorite),
                  color: word.isFavorite
                      ? AppTheme.secondary
                      : AppTheme.textSecondary,
                  size: 22,
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Chevron arrow
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
