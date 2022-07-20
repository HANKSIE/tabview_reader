import 'package:flutter/foundation.dart';
import 'package:tabview_reader/models/sheet_music.dart';
import 'package:tabview_reader/utils/tabview/reader.dart';

class TabviewReaderStore with ChangeNotifier {
  TabviewReader? _reader;
  get reader => _reader;

  build(
      {required int viewHeight,
      required int lineHeight,
      required SheetMusic sheetMusic}) {
    _reader = TabviewReader(
        viewHeight: viewHeight, lineHeight: lineHeight, sheetMusic: sheetMusic);
    notifyListeners();
  }

  next() {
    var isDone = _reader?.next();
    notifyListeners();
    return isDone;
  }

  prev() {
    var isDone = _reader?.next();
    notifyListeners();
    return isDone;
  }
}
