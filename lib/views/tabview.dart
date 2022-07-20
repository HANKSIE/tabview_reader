import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader.dart';
import 'package:tabview_reader/widgets/reader_controls.dart';
import 'package:tabview_reader/widgets/reader_sheet_music_controls.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);
  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  final _viewKey = GlobalKey();
  late final TextStyle _lineStyle;

  @override
  void initState() {
    var settingsStore = Provider.of<SettingsStore>(context, listen: false);
    _lineStyle = TextStyle(
        height: settingsStore.fontHeight, fontSize: settingsStore.fontSize);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const TabviewReaderSheetMusicControls(),
            TabviewReaderControls(
              viewKey: _viewKey,
            )
          ])
        ]),
        body: Builder(
          key: _viewKey,
          builder: (context) {
            return Consumer<TabviewReaderStore>(
              builder: (context, store, child) {
                return store.reader == null
                    ? const Center(
                        child: Text(
                        '開始彈奏吧',
                        style: TextStyle(fontSize: 30),
                      ))
                    : Column(children: [
                        Text('line 1', style: _lineStyle),
                        Text('line 2', style: _lineStyle),
                      ]);
              },
            );
          },
        ));
  }
}
