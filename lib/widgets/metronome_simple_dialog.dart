import 'package:flutter/material.dart';
import 'package:tabview_reader/utils/metronome.dart';

class MetronomeSimpleDialog extends StatefulWidget {
  const MetronomeSimpleDialog({Key? key}) : super(key: key);

  @override
  State<MetronomeSimpleDialog> createState() => _MetronomeSimpleDialogState();
}

class _MetronomeSimpleDialogState extends State<MetronomeSimpleDialog> {
  final _metronome = Metronome(bpm: 40);

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
                  _metronome.stop();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close))
          ],
        ),
        SimpleDialogOption(
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: '${_metronome.bpm.toInt()}',
                  style: const TextStyle(fontSize: 50)),
              const WidgetSpan(child: SizedBox(width: 10)),
              const TextSpan(text: '每分鐘心跳數 (BPM)'),
            ]),
          ),
        ),
        SimpleDialogOption(
          child: Slider(
            value: _metronome.bpm,
            min: 40,
            max: 218,
            divisions: 218 - 40,
            label: '${_metronome.bpm.toInt()} BPM',
            onChanged: (double val) {
              setState(() {
                _metronome.bpm = val;
              });
              if (_metronome.isPlaying) {
                _metronome.restart();
              }
            },
          ),
        ),
        SimpleDialogOption(
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: '${_metronome.beat}',
                  style: const TextStyle(fontSize: 50)),
              const WidgetSpan(child: SizedBox(width: 10)),
              const TextSpan(text: 'Beat'),
            ]),
          ),
        ),
        SimpleDialogOption(
          child: Slider(
            value: _metronome.beat.toDouble(),
            min: 1,
            max: 12,
            divisions: 11,
            label: '${_metronome.beat} Beat',
            onChanged: (double val) {
              setState(() {
                _metronome.beat = val.toInt();
              });
              if (_metronome.isPlaying) {
                _metronome.restart();
              }
            },
          ),
        ),
        SimpleDialogOption(
            child: IconButton(
                icon:
                    Icon(_metronome.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () async {
                  setState(() {
                    if (!_metronome.isPlaying) {
                      _metronome.restart();
                    } else {
                      _metronome.stop();
                    }
                  });
                })),
      ],
    );
  }
}
