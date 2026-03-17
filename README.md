# 🇫🇷 Visual French–English Dictionary

A beautiful, fully offline bilingual illustrated dictionary app built with Flutter.
Learn French vocabulary with images, audio pronunciation, and example sentences.

---

## ✨ Features

| Feature | Details |
|---|---|
| 📂 6 Categories | Animals, Food, House, School, Transport, Nature |
| 📖 50 Words | Pre-seeded SQLite database (expandable) |
| 🔍 Search | Real-time search in French AND English |
| ❤️ Favorites | Save words; persisted across sessions |
| 🔊 Audio | Pronunciation button per word |
| 🌐 Offline | 100% offline — SQLite + local assets |
| 📱 Responsive | Portrait-optimised mobile UI |

---

## 🗂 Project Structure

```
visual_french_dict/
├── lib/
│   ├── main.dart                    # Entry point, SplashScreen
│   ├── models/
│   │   ├── word.dart                # Word data model + DB mapping
│   │   └── category.dart            # Category model + kCategories list
│   ├── services/
│   │   ├── database_service.dart    # SQLite CRUD operations
│   │   ├── seed_data.dart           # 50-word dataset
│   │   ├── audio_service.dart       # Audio playback wrapper
│   │   └── dictionary_provider.dart # ChangeNotifier state manager
│   ├── screens/
│   │   ├── home_screen.dart         # Category grid + bottom nav
│   │   ├── word_list_screen.dart    # Scrollable word list per category
│   │   ├── word_detail_screen.dart  # Full word detail with audio
│   │   ├── search_screen.dart       # French/English search
│   │   └── favorites_screen.dart   # Saved favorites list
│   ├── widgets/
│   │   ├── category_card.dart       # Grid card for each category
│   │   ├── word_tile.dart           # Row tile for word lists
│   │   ├── word_image.dart          # Image/emoji renderer
│   │   ├── audio_button.dart        # Animated play button
│   │   └── search_bar_widget.dart   # Reusable search input
│   └── utils/
│       └── app_theme.dart           # Colors, typography, ThemeData
├── assets/
│   ├── images/                      # Word illustration PNGs (512×512)
│   └── audio/                       # Pronunciation MP3s
├── android/
│   └── app/
│       ├── build.gradle
│       └── src/main/AndroidManifest.xml
├── ios/
│   └── Runner/
│       └── Info.plist
└── pubspec.yaml
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0  ([install guide](https://docs.flutter.dev/get-started/install))
- Android Studio / Xcode
- A physical device or emulator

### Run the app

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on connected device / emulator
flutter run

# 3. Build release APK (Android)
flutter build apk --release

# 4. Build for iOS
flutter build ios --release
```

---

## 🗄 Database Schema

```sql
CREATE TABLE words (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  french      TEXT NOT NULL,
  english     TEXT NOT NULL,
  image       TEXT NOT NULL,   -- e.g. "emoji:🐕" or "assets/images/dog.png"
  audio       TEXT NOT NULL,   -- e.g. "assets/audio/dog.mp3"
  example     TEXT NOT NULL,
  category    TEXT NOT NULL,   -- "animals" | "food" | "house" | "school" | "transport" | "nature"
  is_favorite INTEGER NOT NULL DEFAULT 0   -- 0 = false, 1 = true
);
```

The database is created on first launch at the SQLite default path and seeded
with all 50 words from `lib/services/seed_data.dart`.

---

## 🎨 Adding Real Images

The demo uses emoji rendered in colored containers. To use real illustrations:

1. Place PNG files in `assets/images/` (recommended 512×512, transparent BG)
2. Update the `image` field in `seed_data.dart`:
   ```dart
   // Before (emoji):
   image: 'emoji:🐕',
   // After (real asset):
   image: 'assets/images/dog.png',
   ```
3. Run `flutter pub get && flutter run`

---

## 🔊 Adding Audio Pronunciations

1. Generate French MP3 pronunciations using:
   - **Google Cloud TTS**: voice `fr-FR-Standard-A` or `fr-FR-Wavenet-A`
   - **Amazon Polly**: Mathieu (male) or Céline (female)
   - **ElevenLabs**: custom French voice

2. Name files to match the audio path in `seed_data.dart`:
   - `assets/audio/dog.mp3`, `assets/audio/apple.mp3`, etc.

3. The `AudioButton` widget will automatically play them.

---

## ➕ Adding More Words

Add entries to `kSeedWords` in `lib/services/seed_data.dart`:

```dart
Word(
  french: 'Bibliothèque',
  english: 'Library',
  image: 'emoji:📚',           // or 'assets/images/library.png'
  audio: 'assets/audio/library.mp3',
  example: 'Je vais à la bibliothèque. (I go to the library.)',
  category: 'school',
),
```

> **Note:** After changing `seed_data.dart`, you must delete the app from the
> device (or uninstall) so the database is re-created with the new words.
> Alternatively, implement a database migration (increment the version in
> `database_service.dart` and handle `onUpgrade`).

---

## 🏗 Architecture

```
UI Layer (Screens + Widgets)
        │  watches/reads
        ▼
DictionaryProvider  (ChangeNotifier — lib/services/dictionary_provider.dart)
        │  calls
        ▼
DatabaseService     (SQLite CRUD — lib/services/database_service.dart)
        │  reads/writes
        ▼
SQLite Database     (french_dict.db — device local storage)
```

State flows upward via `notifyListeners()` and `context.watch<DictionaryProvider>()`.
No external network calls are made — the app is fully self-contained.

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `sqflite` | ^2.3.3 | SQLite offline database |
| `path` | ^1.9.0 | File path utilities |
| `audioplayers` | ^6.1.0 | MP3 audio playback |
| `provider` | ^6.1.2 | State management |
| `google_fonts` | ^6.2.1 | Nunito typography |
| `shared_preferences` | ^2.3.3 | Lightweight key-value store |
| `flutter_svg` | ^2.0.10 | SVG icon support |

---

## 📄 License

MIT — free to use, modify, and distribute.
