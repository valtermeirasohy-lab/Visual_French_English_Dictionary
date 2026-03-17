// lib/widgets/audio_button.dart
// Animated button that plays pronunciation audio for a word.

import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../utils/app_theme.dart';

class AudioButton extends StatefulWidget {
  final String audioPath;
  final Color color;

  const AudioButton({
    super.key,
    required this.audioPath,
    this.color = AppTheme.primary,
  });

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton>
    with SingleTickerProviderStateMixin {
  final AudioService _audio = AudioService();
  bool _playing = false;

  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    setState(() => _playing = true);
    _pulse.repeat(reverse: true);
    await _audio.playAsset(widget.audioPath);
    // Stop pulsing after a short delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      _pulse.stop();
      _pulse.reset();
      setState(() => _playing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playing ? null : _play,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, child) {
          final scale = 1.0 + (_pulse.value * 0.06);
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color.withOpacity(0.85), widget.color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _playing ? Icons.volume_up_rounded : Icons.play_circle_outline_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                _playing ? 'Playing…' : 'Listen',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
