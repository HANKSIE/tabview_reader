import 'package:flutter/foundation.dart';
import 'package:tabview_reader/utils/tabview/reader.dart';

class TabviewReaderGroupStore with ChangeNotifier {
  final List<TabviewReader> _readers = [];
  int _songIndex = 0;
  TabviewReader? get reader => _readers.isEmpty ? null : _readers[_songIndex];
  bool get isEmpty => _readers.isEmpty;
  bool get isNotEmpty => _readers.isNotEmpty;

  void restart() {
    for (var reader in _readers) {
      reader.restart();
    }
    _songIndex = 0;
  }

  void reset({int? viewHeight, required int lineHeight}) {
    for (var reader in _readers) {
      reader.reset(viewHeight: viewHeight, lineHeight: lineHeight);
    }
    _songIndex = 0;
  }

  void add({required TabviewReader reader}) {
    _readers.add(reader);
    notifyListeners();
  }

  void clear() {
    _readers.clear();
    notifyListeners();
  }

  bool nextSong() {
    var isDone = _readers.length - 1 == _songIndex;
    if (!isDone) {
      _songIndex++;
      notifyListeners();
    }
    return isDone;
  }

  bool prevSong() {
    var isDone = _songIndex == 0;
    if (!isDone) {
      _songIndex--;
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
