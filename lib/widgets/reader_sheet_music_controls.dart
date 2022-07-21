import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/tabview_reader_group.dart';

class TabviewReaderSheetMusicControls extends StatelessWidget {
  const TabviewReaderSheetMusicControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TabviewReaderGroupStore>(
        builder: (context, readerGroup, child) {
      List<ControlConfig> configs = [
        ControlConfig(
            tip: '關閉', iconData: Icons.close, onPressed: readerGroup.clear),
        ControlConfig(
            tip: '上一首',
            iconData: Icons.keyboard_double_arrow_left,
            onPressed:
                toastWrapper(target: readerGroup.prevSong, doneTip: '已經是第一首了')),
        ControlConfig(
            tip: '上一頁',
            iconData: Icons.keyboard_arrow_left,
            onPressed:
                toastWrapper(target: readerGroup.prevPage, doneTip: '已經是第一頁了')),
        ControlConfig(
            tip: '下一頁',
            iconData: Icons.keyboard_arrow_right,
            onPressed: toastWrapper(
                target: readerGroup.nextPage, doneTip: '已經是最後一頁了')),
        ControlConfig(
            tip: '下一首',
            iconData: Icons.keyboard_double_arrow_right,
            onPressed:
                toastWrapper(target: readerGroup.nextSong, doneTip: '已經是最後一首了'))
      ];
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        for (var config in configs)
          Tooltip(
              message: config.tip,
              child: IconButton(
                  icon: Icon(config.iconData), onPressed: config.onPressed))
      ]);
    });
  }
}

void Function() toastWrapper(
    {required bool Function() target, required String doneTip}) {
  return () {
    var isDone = target();
    if (isDone) {
      Fluttertoast.showToast(msg: doneTip);
    }
  };
}

class ControlConfig {
  String tip;
  IconData iconData;
  void Function() onPressed;
  ControlConfig(
      {required this.tip, required this.iconData, required this.onPressed});
}
