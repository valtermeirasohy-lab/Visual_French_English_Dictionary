// lib/models/word.dart
// Data model representing a single dictionary entry

class Word {
  final int? id;
  final String french;
  final String english;
  final String image;       // asset path, e.g. assets/images/dog.png
  final String audio;       // asset path, e.g. assets/audio/dog.mp3
  final String example;     // example sentence in English
  final String category;    // category slug, e.g. "animals"
  final bool isFavorite;

  const Word({
    this.id,
    required this.french,
    required this.english,
    required this.image,
    required this.audio,
    required this.example,
    required this.category,
    this.isFavorite = false,
  });

  // Convert a Word into a Map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'french': french,
      'english': english,
      'image': image,
      'audio': audio,
      'example': example,
      'category': category,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  // Create a Word from a SQLite row Map
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'] as int?,
      french: map['french'] as String,
      english: map['english'] as String,
      image: map['image'] as String,
      audio: map['audio'] as String,
      example: map['example'] as String,
      category: map['category'] as String,
      isFavorite: (map['is_favorite'] as int) == 1,
    );
  }

  // Copy with updated fields (useful for toggling favorites)
  Word copyWith({
    int? id,
    String? french,
    String? english,
    String? image,
    String? audio,
    String? example,
    String? category,
    bool? isFavorite,
  }) {
    return Word(
      id: id ?? this.id,
      french: french ?? this.french,
      english: english ?? this.english,
      image: image ?? this.image,
      audio: audio ?? this.audio,
      example: example ?? this.example,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() => 'Word(french: $french, english: $english)';
}
