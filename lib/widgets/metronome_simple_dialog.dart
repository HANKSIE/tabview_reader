import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MetronomeSimpleDialog extends StatefulWidget {
  const MetronomeSimpleDialog({Key? key}) : super(key: key);

  @override
  State<MetronomeSimpleDialog> createState() => _MetronomeSimpleDialogState();
}

class _MetronomeSimpleDialogState extends State<MetronomeSimpleDialog> {
  final double _min = 40;
  final double _max = 218;
  double _bpm = 40;
  bool _isPlaying = false;

  late final AudioPlayer _audioPlayer;
  Timer? _timer;
  _MetronomeSimpleDialogState() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setSource(AssetSource('audios/metronome.wav'));
  }

  _restartTimer() {
    _timer?.cancel();
    if (_isPlaying) {
      _timer =
          Timer.periodic(Duration(milliseconds: 60000 ~/ _bpm), (timer) async {
        // restart
        await _audioPlayer.seek(const Duration(milliseconds: 0));
        _audioPlayer.resume();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close))
          ],
        ),
        SimpleDialogOption(
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: '${_bpm.toInt()}',
                  style: const TextStyle(fontSize: 50)),
              const WidgetSpan(child: SizedBox(width: 10)),
              const TextSpan(text: '每分鐘心跳數 (BPM)'),
            ]),
          ),
        ),
        SimpleDialogOption(
          child: Slider(
            value: _bpm,
            min: _min,
            max: _max,
            divisions: (_max - _min).toInt(),
            label: '${_bpm.toInt()} BPM',
            onChanged: (double val) {
              setState(() {
                _bpm = val;
              });
              _restartTimer();
            },
          ),
        ),
        SimpleDialogOption(
            child: IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () async {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });

                  _restartTimer();
                })),
      ],
    );
  }
}
