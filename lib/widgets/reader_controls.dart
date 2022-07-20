import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader.dart';
import 'package:tabview_reader/utils/tabview/parser.dart';
import 'package:tabview_reader/widgets/settings_buttomsheet.dart';

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
      var str = file.readAsStringSync();
      var sheetMusic = TabviewParser.exec(str);
      var lineHeight =
          Provider.of<SettingsStore>(context, listen: false).lineHeight;
      log("view height: ${_getViewHeight()}");
      Provider.of<TabviewReaderStore>(context, listen: false).build(
          viewHeight: _getViewHeight(),
          lineHeight: lineHeight.toInt(),
          sheetMusic: sheetMusic);
    } catch (e) {
      log('Error: $e');
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
