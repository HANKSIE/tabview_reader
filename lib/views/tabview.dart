import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader_group.dart';
import 'package:tabview_reader/widgets/reader_controls.dart';
import 'package:tabview_reader/widgets/reader_sheet_music_controls.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);
  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  final _viewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Consumer<TabviewReaderGroupStore>(
                builder: (context, readerGroup, child) {
              return readerGroup.isEmpty
                  ? const SizedBox.shrink()
                  : const TabviewReaderSheetMusicControls();
            }),
            TabviewReaderControls(
              viewKey: _viewKey,
            )
          ])
        ]),
        body: Builder(
          key: _viewKey,
          builder: (context) {
            return Consumer2<TabviewReaderGroupStore, SettingsStore>(
              builder: (context, readerGroup, settings, child) {
                return readerGroup.isEmpty
                    ? const Center(
                        child: Text(
                        '開始彈奏吧',
                        style: TextStyle(fontSize: 30),
                      ))
                    : OverflowBox(
                        maxWidth: double.infinity,
                        child:
                        SingleChildScrollView(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var text in readerGroup.reader?.page)
                                Text(text,
                                    style: TextStyle(
                                      height: settings.fontHeight,
                                      fontSize: settings.fontSize,
                                      fontFamily: 'Roboto Mono',
                                    ))
                            ]))
                        );
              },
            );
          },
        ));
  }
}
