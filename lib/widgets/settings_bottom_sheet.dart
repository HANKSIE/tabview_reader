import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

    List<ControlConfig> configs = [
      ControlConfig(
        label: '字體大小 ${settingsStore.fontSize}',
        slide: SlideControlConfig(
            value: settingsStore.fontSize,
            min: 5.0,
            max: 50.0,
            divisions: 45,
            onChange: (double val) {
              settingsStore.setFontSize(double.parse(val.toStringAsFixed(1)));
              readerGroupStore.reset(lineHeight: settingsStore.lineHeight);
            }),
      ),
      ControlConfig(
        label: '字體高度 ${settingsStore.fontHeight}',
        slide: SlideControlConfig(
            value: settingsStore.fontHeight,
            min: 1.2,
            max: 10.0,
            divisions: 88,
            onChange: (double val) {
              settingsStore.setFontHeight(double.parse(val.toStringAsFixed(1)));
              readerGroupStore.reset(lineHeight: settingsStore.lineHeight);
            }),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(50),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
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
                    value: config.slide.value,
                    min: config.slide.min,
                    max: config.slide.max,
                    divisions: config.slide.divisions,
                    label: config.slide.value.toString(),
                    onChanged: config.slide.onChange,
                  ))
                ])
            ],
            [
              Row(children: [
                const Expanded(
                  child: Text(
                    '深色主題',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                    child: Switch(
                  value: settingsStore.isDarkTheme,
                  onChanged: (bool value) {
                    settingsStore.toggleTheme();
                  },
                ))
              ]),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () async {
                  await settingsStore.save();
                  Fluttertoast.showToast(msg: '已儲存');
                },
                child: const Text('儲存'),
              ),
            ]
          ].expand((widget) => widget).toList(),
        ),
      ]),
    );
  }
}

class ControlConfig {
  String label;
  SlideControlConfig slide;
  ControlConfig({required this.label, required this.slide});
}

class SlideControlConfig {
  double value;
  double max;
  double min;
  int divisions;
  void Function(double) onChange;
  SlideControlConfig(
      {required this.value,
      required this.max,
      required this.min,
      required this.divisions,
      required this.onChange});
}
