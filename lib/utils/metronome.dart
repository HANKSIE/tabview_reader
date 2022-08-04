import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class Metronome {
  late double bpm;
  int beat = 4;
  int _currentBeat = 0;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  final _audioPlayer = AudioPlayer();
  Timer? _timer;

  Metronome({required this.bpm}) {
    _audioPlayer.setSource(AssetSource('audios/metronome.wav'));
  }

  restart() {
    _currentBeat = 0;
    _isPlaying = true;
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: 60000 ~/ bpm), (timer) async {
      // restart
      await _audioPlayer.seek(const Duration(milliseconds: 0));
      final double volume = _currentBeat == 0 && beat > 1 ? 1 : 0.4;
      _audioPlayer
        ..setVolume(volume)
        ..resume();
      _currentBeat = _currentBeat == beat - 1 ? 0 : _currentBeat + 1;
    });
  }

  stop() {
    _timer?.cancel();
    _isPlaying = false;
  }
}
