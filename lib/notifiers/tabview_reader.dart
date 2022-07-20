import 'package:flutter/foundation.dart';
import 'package:tabview_reader/utils/tabview/reader.dart';

class TabviewReaderNotifier with ChangeNotifier {
  List<TabViewReader> _readers = [];
  List<String> lines = [];
  List<TabViewReader> get readers => _readers;

  increment() {
    notifyListeners();
  }
}
