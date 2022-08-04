import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader_group.dart';
import 'package:tabview_reader/utils/tabview/parser.dart';
import 'package:tabview_reader/utils/tabview/reader.dart';
import 'package:tabview_reader/widgets/metronome_simple_dialog.dart';
import 'package:tabview_reader/widgets/settings_bottom_sheet.dart';

class TabviewReaderControls extends StatefulWidget {
  const TabviewReaderControls({Key? key}) : super(key: key);
  @override
  State<TabviewReaderControls> createState() => _NormalControlsState();
}

class _NormalControlsState extends State<TabviewReaderControls> {
  _createReaderFromPicker() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final sheetMusic =
          TabviewParser.exec(name: path.basename(file.path), content: content);
      final lineHeight =
          Provider.of<SettingsStore>(context, listen: false).lineHeight;

      final readerGroupStore =
          Provider.of<TabviewReaderGroupStore>(context, listen: false);

      readerGroupStore.clearAndRestart();
      readerGroupStore.add(
          reader: TabviewReader(
              viewHeight: readerGroupStore.viewHeight,
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
        message: '節拍器',
        child: IconButton(
            icon: const Icon(IconData(0xf70b,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage)),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const MetronomeSimpleDialog();
                  });
            }),
      ),
      Tooltip(
        message: '選擇檔案',
        child: IconButton(
            icon: const Icon(Icons.file_open),
            onPressed: _createReaderFromPicker),
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
