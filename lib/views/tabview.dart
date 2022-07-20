import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tabview_reader/utils/tabview/parser.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);
  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  final _viewKey = GlobalKey();
  late final Widget _toggles;
  _TabViewPageState() {
    _toggles = Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_left),
          onPressed: () {
            log('double left');
            _getSize();
          }),
      IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            log('left');
          }),
      IconButton(
        icon: const Icon(Icons.keyboard_arrow_right),
        onPressed: () {
          log('right');
        },
      ),
      IconButton(
        icon: const Icon(Icons.keyboard_double_arrow_right),
        onPressed: () {
          log('double right');
        },
      )
    ]);
  }
  _fileOpen() async {
    try {
      var result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      var file = File(result.files.single.path!);
      var str = file.readAsStringSync();
      var sheetMusic = TabviewParser.exec(str);
    } catch (e) {
      log('Error: $e');
    }
  }

  void _getSize() {
    final size = _viewKey.currentContext!.size;
    log('get size');
    if (size != null) {
      log('view height: ${size.height}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _toggles,
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              IconButton(
                  icon: const Icon(Icons.file_open), onPressed: _fileOpen),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).pushNamed('/search');
                },
              )
            ])
          ])
        ]),
        body: Builder(
          key: _viewKey,
          builder: (context) {
            return Column(children: const [
              Text('line 1'),
              Text('line 2'),
            ]);
          },
        ));
  }
}
