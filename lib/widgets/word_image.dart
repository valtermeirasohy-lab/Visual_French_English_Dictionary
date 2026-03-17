// lib/widgets/word_image.dart
// Renders the "image" field from a Word.
// For the demo, images use an "emoji:" prefix (e.g. "emoji:🐕").
// This widget renders the emoji in a colored rounded container.
// In production, replace with Image.asset() for real PNG files.

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class WordImage extends StatelessWidget {
  final String imagePath;   // e.g. "emoji:🐕" or "assets/images/dog.png"
  final String category;    // used for background color
  final double size;        // container size in logical pixels

  const WordImage({
    super.key,
    required this.imagePath,
    required this.category,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.categoryColor(category);

    if (imagePath.startsWith('emoji:')) {
      // ── Emoji rendering mode ─────────────────────────────────────────────
      final emoji = imagePath.substring(6); // strip "emoji:" prefix
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(size * 0.25),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(fontSize: size * 0.5),
          ),
        ),
      );
    } else {
      // ── Real asset image mode ─────────────────────────────────────────────
      return ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.25),
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            color: color.withOpacity(0.12),
            child: Icon(Icons.image_not_supported_outlined,
                color: color, size: size * 0.4),
          ),
        ),
      );
    }
  }
}
