import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:tabview_reader/store/search_payload.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader_group.dart';
import 'package:tabview_reader/utils/tabview/parser.dart';
import 'package:tabview_reader/utils/tabview/reader.dart';
import 'package:tabview_reader/utils/tabview/validation.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key}) : super(key: key);
  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final List<File> _files = [];
  final List<File> _selects = [];
  String? _error;
  double _progress = 0;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _search(ModalRoute.of(context)!.settings.arguments as SearchPayload);
    });
  }

  _search(SearchPayload payload) async {
    final validation =
        TabviewValidation(keyword: payload.keyword, selects: payload.selects);
    setState(() {
      _files.clear();
    });
    try {
      // final entitiesStream = Directory(payload.dir).list(recursive: true);
      final entitiesCount =
          await Directory(payload.dir).list(recursive: true).length;
      final divisions = 100 / entitiesCount;
      await for (final entity in Directory(payload.dir).list(recursive: true)) {
        if (entity is File) {
          final filename = path.basename(entity.path);
          if (validation.exec(filename)) {
            setState(() {
              _files.add(entity);
            });
          }
        }
        setState(() {
          _progress += divisions;
        });
      }
    } catch (err) {
      _error = err.toString();
    }
  }

  _initReaders() async {
    if (_selects.isEmpty) {
      Fluttertoast.showToast(msg: '需要至少一個樂譜');
      return;
    }
    final readerGroupStore =
        Provider.of<TabviewReaderGroupStore>(context, listen: false);
    final lineHeight =
        Provider.of<SettingsStore>(context, listen: false).lineHeight;
    readerGroupStore.clearAndRestart();
    for (final file in _selects) {
      final sheetMusic = TabviewParser.exec(
          name: path.basename(file.path), content: await file.readAsString());
      readerGroupStore.add(
          reader: TabviewReader(
              viewHeight: readerGroupStore.viewHeight,
              lineHeight: lineHeight,
              sheetMusic: sheetMusic));
    }
    Navigator.of(context).pushNamed('/tabview');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: _error == null
            ? Container(
                padding: const EdgeInsets.all(30),
                child: _progress.round() < 100
                    ? Center(
                        child: IntrinsicHeight(
                            child: Column(
                        children: [
                          Text(
                            '搜尋中... ${_progress.round()}%',
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 30),
                          LinearProgressIndicator(
                            value: _progress,
                            minHeight: 30,
                            semanticsLabel: '$_progress %',
                          )
                        ],
                      )))
                    : Column(
                        children: [
                          Expanded(
                              flex: 11,
                              child: ListView(
                                children: [
                                  ...[
                                    for (final file in _files)
                                      CheckboxListTile(
                                          checkColor: Colors.teal,
                                          title: Text(path.basename(file.path)),
                                          value: _selects.contains(file),
                                          onChanged: (bool? value) {
                                            if (value == null) return;
                                            setState(() {
                                              value
                                                  ? _selects.add(file)
                                                  : _selects.remove(file);
                                            });
                                          })
                                  ],
                                ],
                              )),
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                      ),
                                      onPressed: _initReaders,
                                      child: const Text('播放')))
                            ],
                          ))
                        ],
                      ))
            : Text(
                _error!,
                style: const TextStyle(fontSize: 30),
              ));
  }
}
