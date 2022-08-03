import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader_group.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({Key? key}) : super(key: key);

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context, listen: true);
    final readerGroupStore =
        Provider.of<TabviewReaderGroupStore>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(50),
      child: ListView(
        children: [
          Row(children: [
            Expanded(
              child: Text(
                '字體大小 ${settingsStore.fontSize}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
                child: Slider(
                    value: settingsStore.fontSize,
                    min: 5.0,
                    max: 50.0,
                    divisions: 45,
                    onChanged: (double val) {
                      settingsStore
                          .setFontSize(double.parse(val.toStringAsFixed(1)));
                      readerGroupStore.reset(
                          lineHeight: settingsStore.lineHeight);
                    }))
          ]),
          Row(children: [
            const Expanded(
              child: Text(
                '保持開啟',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
                child: Switch(
              value: settingsStore.wakeUp,
              onChanged: (bool value) {
                settingsStore.setWakeUp(value);
              },
            )),
          ]),
          Row(children: [
            const Expanded(
              child: Text(
                '深色主題',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
                child: Switch(
              value: settingsStore.dark,
              onChanged: (bool value) {
                settingsStore.toggleTheme();
              },
            ))
          ]),
        ],
      ),
    );
  }
}
