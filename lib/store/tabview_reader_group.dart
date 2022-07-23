import 'package:flutter/material.dart';
import 'package:tabview_reader/utils/tabview/reader.dart';

class TabviewReaderGroupStore with ChangeNotifier {
  final List<TabviewReader> _readers = [];
  int _songIndex = 0;
  TabviewReader? get reader => _readers.isEmpty ? null : _readers[_songIndex];
  bool get isEmpty => _readers.isEmpty;
  bool get isNotEmpty => _readers.isNotEmpty;

  GlobalKey<State<StatefulWidget>>? viewKey;

  setViewKey(GlobalKey<State<StatefulWidget>> key) {
    viewKey = key;
    notifyListeners();
  }

  get viewHeight {
    final size = viewKey?.currentContext?.size;
    return size?.height ?? 0;
  }

  void restart() {
    for (final reader in _readers) {
      reader.restart();
    }
    _songIndex = 0;
    notifyListeners();
  }

  void reset({num? viewHeight, required num lineHeight}) {
    for (final reader in _readers) {
      reader.reset(viewHeight: viewHeight, lineHeight: lineHeight);
    }
    notifyListeners();
  }

  void add({required TabviewReader reader}) {
    _readers.add(reader);
    notifyListeners();
  }

  void clearAndRestart() {
    _readers.clear();
    _songIndex = 0;
    notifyListeners();
  }

  bool nextSong() {
    var isDone = _readers.length - 1 == _songIndex;
    if (!isDone) {
      _songIndex++;
      reader?.restart();
      notifyListeners();
    }
    return isDone;
  }

  bool prevSong() {
    var isDone = _songIndex == 0;
    if (!isDone) {
      _songIndex--;
      reader?.restart();
      notifyListeners();
    }
    return isDone;
  }

  bool nextPage() {
    var isDone = reader?.next();
    notifyListeners();
    return isDone;
  }

  bool prevPage() {
    var isDone = reader?.prev();
    notifyListeners();
    return isDone;
  }
}
