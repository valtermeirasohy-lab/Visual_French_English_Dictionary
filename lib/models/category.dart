// lib/models/category.dart
// Represents a vocabulary category shown on the home screen

class Category {
  final String id;       // slug used in database (e.g. "animals")
  final String name;     // display name (e.g. "Animals")
  final String nameFr;   // French display name (e.g. "Animaux")
  final String emoji;    // emoji icon for the category card
  final int color;       // ARGB color value for card background

  const Category({
    required this.id,
    required this.name,
    required this.nameFr,
    required this.emoji,
    required this.color,
  });
}

// All six categories used in the app
const List<Category> kCategories = [
  Category(
    id: 'animals',
    name: 'Animals',
    nameFr: 'Animaux',
    emoji: '🐾',
    color: 0xFFFF6B6B, // coral red
  ),
  Category(
    id: 'food',
    name: 'Food',
    nameFr: 'Nourriture',
    emoji: '🍎',
    color: 0xFFFFB347, // orange
  ),
  Category(
    id: 'house',
    name: 'House',
    nameFr: 'Maison',
    emoji: '🏠',
    color: 0xFF6BCB77, // green
  ),
  Category(
    id: 'school',
    name: 'School',
    nameFr: 'École',
    emoji: '📚',
    color: 0xFF4D96FF, // blue
  ),
  Category(
    id: 'transport',
    name: 'Transport',
    nameFr: 'Transport',
    emoji: '🚗',
    color: 0xFFAD7BE9, // purple
  ),
  Category(
    id: 'nature',
    name: 'Nature',
    nameFr: 'Nature',
    emoji: '🌿',
    color: 0xFF56CFE1, // teal
  ),
];
