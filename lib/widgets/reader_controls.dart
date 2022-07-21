import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader_group.dart';
import 'package:tabview_reader/utils/tabview/parser.dart';
import 'package:tabview_reader/utils/tabview/reader.dart';
import 'package:tabview_reader/widgets/settings_bottom_sheet.dart';

class TabviewReaderControls extends StatefulWidget {
  const TabviewReaderControls({Key? key, required this.viewKey})
      : super(key: key);
  final GlobalKey<State<StatefulWidget>> viewKey;
  @override
  State<TabviewReaderControls> createState() => _NormalControlsState();
}

class _NormalControlsState extends State<TabviewReaderControls> {
  int _getViewHeight() {
    final size = widget.viewKey.currentContext?.size;
    return size != null ? size.height.toInt() : 0;
  }

  _fileOpen() async {
    try {
      var result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      var file = File(result.files.single.path!);
      var content = file.readAsStringSync();
      var sheetMusic =
          TabviewParser.exec(name: path.basename(file.path), content: content);
      var lineHeight =
          Provider.of<SettingsStore>(context, listen: false).lineHeight;
      var readerGroupStore =
          Provider.of<TabviewReaderGroupStore>(context, listen: false);
      readerGroupStore.clear();
      readerGroupStore.add(
          reader: TabviewReader(
              viewHeight: _getViewHeight(),
              lineHeight: lineHeight,
              sheetMusic: sheetMusic));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Tooltip(
        message: '選擇檔案',
        child:
            IconButton(icon: const Icon(Icons.file_open), onPressed: _fileOpen),
      ),
      Tooltip(
        message: '搜尋',
        child: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).pushNamed('/search');
          },
        ),
      ),
      Tooltip(
        message: '設定',
        child: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const SettingsBottomSheet();
                  });
            }),
      ),
    ]);
  }
}
