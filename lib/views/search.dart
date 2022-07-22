import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:tabview_reader/models/radio_control_config.dart';
import 'package:tabview_reader/utils/tabview/validation.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int? _selected1 = 0;
  int? _selected2 = 0;
  int? _selected3 = 0;
  int? _selected4 = 0;
  final List<File> _files = [];
  final String _keyword = '';
  _search() async {
    String? dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null) return;
    try {
      final fileStream = _scanningFilesWithAsyncRecursive(Directory(dir));
      final validation = TabviewValidation(
          keyword: _keyword,
          selects: '$_selected1$_selected2$_selected3$_selected4');
      _files.clear();
      await for (final file in fileStream) {
        final filename = path.basename(file.path);
        if (validation.exec(filename)) {
          _files.add(file);
        }
      }
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error: $err');
    }
  }

  Stream<File> _scanningFilesWithAsyncRecursive(Directory dir) async* {
    var dirList = dir.list();
    await for (final FileSystemEntity entity in dirList) {
      if (entity is File) {
        yield entity;
      } else if (entity is Directory) {
        yield* _scanningFilesWithAsyncRecursive(Directory(entity.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['ignore', 'option1', 'option2', 'option3', 'option4'];
    final config1 = RadioControlConfig<int>(
        label: '條件1',
        groupValue: _selected1,
        onChange: (int? val) => setState(() {
              _selected1 = val;
            }),
        units: [
          for (int i = 0; i < 5; i++)
            RadioControlUnitConfig<int>(label: labels[i], value: i),
        ]);
    final config2 = RadioControlConfig<int>(
        label: '條件2',
        groupValue: _selected2,
        onChange: (int? val) => setState(() {
              _selected2 = val;
            }),
        units: [
          for (int i = 0; i < 5; i++)
            RadioControlUnitConfig<int>(label: labels[i], value: i),
        ]);
    final config3 = RadioControlConfig<int>(
        label: '條件3',
        groupValue: _selected3,
        onChange: (int? val) => setState(() {
              _selected3 = val;
            }),
        units: [
          for (int i = 0; i < 5; i++)
            RadioControlUnitConfig<int>(label: labels[i], value: i),
        ]);
    final config4 = RadioControlConfig<int>(
        label: '條件4',
        groupValue: _selected4,
        onChange: (int? val) => setState(() {
              _selected4 = val;
            }),
        units: [
          for (int i = 0; i < 5; i++)
            RadioControlUnitConfig<int>(label: labels[i], value: i),
        ]);
    final configs = [config1, config2, config3, config4];
    int i = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜尋'),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
          [
            for (final config in configs)
              Column(children: [
                Text(config.label),
                for (final unit in config.units)
                  RadioListTile<int>(
                    title: Text(unit.label),
                    groupValue: config.groupValue,
                    value: unit.value,
                    onChanged: config.onChange,
                  )
              ])
          ],
          [TextButton(onPressed: _search, child: const Text('搜尋'))]
        ].expand((widget) => widget).toList()),
      ),
    );
  }
}
