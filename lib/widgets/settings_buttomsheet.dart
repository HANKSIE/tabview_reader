import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/settings.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({Key? key}) : super(key: key);

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var settingsStore = Provider.of<SettingsStore>(context, listen: true);
    var fontSize = settingsStore.fontSize;
    var setFontSize = settingsStore.setFontSize;
    var fontHeight = settingsStore.fontHeight;
    var setFontHeight = settingsStore.setFontHeight;
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(children: [
        Row(children: [
          const Expanded(
            child: Text(
              'font size',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
              child: Slider(
            value: fontSize,
            max: 50,
            divisions: 50,
            label: fontSize.toString(),
            onChanged: (double value) {
              setFontSize(value);
            },
          ))
        ]),
        Row(children: [
          const Expanded(
            child: Text(
              'font height',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
              child: Slider(
            value: fontHeight,
            max: 50,
            divisions: 50,
            label: fontHeight.toString(),
            onChanged: (double value) {
              setFontHeight(value);
            },
          ))
        ])
      ]),
    );
  }
}
