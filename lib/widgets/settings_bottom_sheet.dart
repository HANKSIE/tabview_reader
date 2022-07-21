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
          label: '字體大小',
          slide: SlideControlConfig(
              value: settingsStore.fontSize,
              min: 5.0,
              max: 50.0,
              divisions: 45,
              onChange: (double val) {
                settingsStore.setFontSize(val);
                readerGroupStore.reset(lineHeight: settingsStore.lineHeight);
              }),
          textField: TextFieldControlConfig(
              controller: TextEditingController(
                  text: settingsStore.fontSize.toString()),
              change: (controller, val) {
                controller.text = val;
                settingsStore.setFontSize(double.parse(val));
              })),
      ControlConfig(
          label: '字體高度',
          slide: SlideControlConfig(
              value: settingsStore.fontHeight,
              min: 1.2,
              max: 10.0,
              divisions: 88,
              onChange: (double val) {
                settingsStore.setFontHeight(val);
                readerGroupStore.reset(lineHeight: settingsStore.lineHeight);
              }),
          textField: TextFieldControlConfig(
              controller: TextEditingController(
                  text: settingsStore.fontHeight.toString()),
              change: (controller, val) {
                controller.text = val;
                settingsStore.setFontSize(double.parse(val));
              })),
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
                    flex: 2,
                    child: Text(
                      config.label,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: config.textField.controller,
                      )),
                  Expanded(
                      flex: 2,
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
              ])
            ]
          ].expand((widget) => widget).toList(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20)),
          onPressed: () async {
            await settingsStore.save();
            Fluttertoast.showToast(msg: '已儲存');
          },
          child: const Text('儲存'),
        ),
      ]),
    );
  }
}

class ControlConfig {
  String label;
  SlideControlConfig slide;
  TextFieldControlConfig textField;
  ControlConfig(
      {required this.label, required this.slide, required this.textField});
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

class TextFieldControlConfig {
  late TextEditingController controller;
  late void Function(String val) onChange;
  TextFieldControlConfig(
      {required this.controller,
      required void Function(TextEditingController controller, String val)
          change}) {
    onChange = (String val) {
      change(controller, val);
    };
  }
}
