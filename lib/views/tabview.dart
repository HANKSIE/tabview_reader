import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader_group.dart';
import 'package:tabview_reader/utils/tabview/readerControlWrapper.dart';
import 'package:tabview_reader/utils/throttle.dart';
import 'package:tabview_reader/widgets/reader_controls.dart';
import 'package:tabview_reader/widgets/reader_sheet_music_controls.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);
  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  final _viewKey = GlobalKey();
  Orientation? _orientation;

  late final Function _prevPage;
  late final Function _nextPage;
  late final Function _nextPageThrottle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final readerGroupStore =
          Provider.of<TabviewReaderGroupStore>(context, listen: false);

      readerGroupStore.setViewKey(_viewKey);

      _prevPage = readerControlWrapper(
          target: readerGroupStore.prevPage, doneTip: '已經是第一頁了');

      _nextPage = readerControlWrapper(
          target: readerGroupStore.nextPage, doneTip: '已經是最後一頁了');

      _nextPageThrottle = throttle(_nextPage, 1500);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Consumer<TabviewReaderGroupStore>(
                builder: (context, readerGroup, child) {
              return readerGroup.isEmpty
                  ? const SizedBox.shrink()
                  : const TabviewReaderSheetMusicControls();
            }),
            const TabviewReaderControls()
          ])
        ]),
        body: Consumer2<TabviewReaderGroupStore, SettingsStore>(
            builder: (context, readerGroup, settings, child) {
          return OrientationBuilder(builder: (context, orientation) {
            if (_orientation != null && _orientation != orientation) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                readerGroup.reset(
                    lineHeight: settings.lineHeight,
                    viewHeight: _viewKey.currentContext?.size?.height ?? 0);
              });
            }
            _orientation = orientation;

            return Builder(
              key: _viewKey,
              builder: (context) {
                return readerGroup.isEmpty
                    ? const Center(
                        child: Text(
                        '還沒選擇任何樂譜',
                        style: TextStyle(fontSize: 30),
                      ))
                    : GestureDetector(
                        onTapUp: (TapUpDetails details) {
                          _nextPageThrottle();
                        },
                        onHorizontalDragEnd: (DragEndDetails details) {
                          if (details.velocity.pixelsPerSecond.dx > 0) {
                            _prevPage();
                          }
                          if (details.velocity.pixelsPerSecond.dx < 0) {
                            _nextPage();
                          }
                        },
                        child: ListView(children: [
                          for (final text in readerGroup.reader?.page)
                            Text(text,
                                style: TextStyle(
                                  height: settings.fontHeight,
                                  fontSize: settings.fontSize,
                                  fontFamily: 'Roboto Mono',
                                ))
                        ]));
              },
            );
          });
        }));
  }
}
