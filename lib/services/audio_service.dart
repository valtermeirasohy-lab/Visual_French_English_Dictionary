// lib/services/audio_service.dart
// Wraps the audioplayers package to play pronunciation audio from assets.

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  /// Play an audio asset located at [assetPath].
  /// If audio is already playing, stop it first.
  Future<void> playAsset(String assetPath) async {
    if (_isPlaying) {
      await _player.stop();
    }
    try {
      _isPlaying = true;
      // audioplayers v6: use AssetSource for bundled assets
      await _player.play(AssetSource(
        // Strip the leading "assets/" because AssetSource adds it automatically
        assetPath.replaceFirst('assets/', ''),
      ));
      _player.onPlayerComplete.listen((_) {
        _isPlaying = false;
      });
    } catch (e) {
      // Audio file may not exist in demo; silently handle
      _isPlaying = false;
      debugPrint('AudioService: could not play $assetPath — $e');
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
