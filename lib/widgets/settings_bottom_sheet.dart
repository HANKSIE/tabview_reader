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
    List<SlideControlConfig> configs = [
      SlideControlConfig(
          label: 'font size',
          value: settingsStore.fontSize,
          min: 5.0,
          max: 50.0,
          divisions: 45,
          onChange: (double val) {
            settingsStore.setFontSize(val);
            readerGroupStore.reset(lineHeight: settingsStore.lineHeight);
          }),
      SlideControlConfig(
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
          for (var config in configs)
            Row(children: [
              Expanded(
                child: Text(
                  config.label,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                  child: Slider(
                value: config.value,
                min: config.min,
                max: config.max,
                divisions: config.divisions,
                label: config.value.toString(),
                onChanged: config.onChange,
              ))
            ])
        ]
      ].expand((widget) => widget).toList()),
    );
  }
}

class SlideControlConfig {
  String label;
  double value;
  double max;
  double min;
  int divisions;
  void Function(double) onChange;
  SlideControlConfig(
      {required this.label,
      required this.value,
      required this.max,
      required this.min,
      required this.divisions,
      required this.onChange});
}
