import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:tabview_reader/store/search_payload.dart';
import 'package:tabview_reader/utils/tabview/validation.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final List<File> _files = [];

  _search(SearchPayload payload) async {
    try {
      final validation =
          TabviewValidation(keyword: payload.keyword, selects: payload.selects);
      _files.clear();

      await for (final entity in Directory(payload.dir).list(recursive: true)) {
        if (entity is File) {
          final filename = path.basename(entity.path);
          if (validation.exec(filename)) {
            _files.add(entity);
          }
        }
      }
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error: $err');
    }

    for (final file in _files) {
      log(path.basename(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final payload = ModalRoute.of(context)!.settings.arguments as SearchPayload;
    _search(payload);
    return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('搜尋結果'),
        ));
  }
}
