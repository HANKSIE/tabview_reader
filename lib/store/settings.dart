import 'package:flutter/foundation.dart';

class SettingsStore with ChangeNotifier {
  double _fontSize = 8;
  double _fontHeight = 1.2;
  get fontSize => _fontSize;
  get fontHeight => _fontHeight;
  get lineHeight => _fontSize * _fontHeight;

  setFontSize(double fontSize) {
    _fontSize = fontSize;
    notifyListeners();
  }

  setFontHeight(double fontHeight) {
    _fontHeight = fontHeight;
    notifyListeners();
  }
}
