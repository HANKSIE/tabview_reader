import 'package:flutter/material.dart';
import 'package:tabview_reader/widgets/reader_controls.dart';
import 'package:tabview_reader/widgets/reader_sheet_music_controls.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);
  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  final _viewKey = GlobalKey();
  final _lineStyle = const TextStyle(height: 10, fontSize: 10);

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
            return Column(children: [
              Text('line 1', style: _lineStyle),
              Text('line 2', style: _lineStyle),
            ]);
          },
        ));
  }
}
