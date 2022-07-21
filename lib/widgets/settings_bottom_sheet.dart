import 'dart:developer';

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
    var settingsStore = Provider.of<SettingsStore>(context, listen: true);
    var readerGroupStore =
        Provider.of<TabviewReaderGroupStore>(context, listen: false);
    List<SlideControlSetting> slideControlSetting = [
      SlideControlSetting(
          label: 'font size',
          value: settingsStore.fontSize,
          min: 5.0,
          max: 50.0,
          divisions: 45,
          onChange: (double val) {
            settingsStore.setFontSize(val);
            readerGroupStore.reset(lineHeight: settingsStore.lineHeight);
          }),
      SlideControlSetting(
          label: 'font height',
          value: settingsStore.fontHeight,
          min: 1.2,
          max: 10.0,
          divisions: 88,
          onChange: (double val) {
            settingsStore.setFontHeight(val);
            readerGroupStore.reset(lineHeight: settingsStore.lineHeight);
          }),
    ];
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
          children: [
        [
          for (var setting in slideControlSetting)
            Row(children: [
              Expanded(
                child: Text(
                  setting.label,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                  child: Slider(
                value: setting.value,
                min: setting.min,
                max: setting.max,
                divisions: setting.divisions,
                label: setting.value.toString(),
                onChanged: setting.onChange,
              ))
            ])
        ]
      ].expand((widget) => widget).toList()),
    );
  }
}

typedef SlideControlSettingOnChangeFunc = void Function(double);

class SlideControlSetting {
  String label;
  double value;
  double max;
  double min;
  int divisions;
  SlideControlSettingOnChangeFunc onChange;
  SlideControlSetting(
      {required this.label,
      required this.value,
      required this.max,
      required this.min,
      required this.divisions,
      required this.onChange});
}
