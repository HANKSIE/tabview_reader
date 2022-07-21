import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabview_reader/utils/setting_storage.dart';

class SettingsStore with ChangeNotifier {
  double _fontSize = 8;
  double _fontHeight = 1.2;
  ThemeMode _theme = ThemeMode.dark;
  SettingStorage? _storage;
  get fontSize => _fontSize;
  get fontHeight => _fontHeight;
  get lineHeight => _fontSize * _fontHeight;
  get theme => _theme;

  get isDarkTheme => _theme == ThemeMode.dark;

  SettingsStore() {
    _init();
  }

  void _init() async {
    try {
      _storage = SettingStorage(await SharedPreferences.getInstance());

      _sync<double>(
          storageValue: _storage!.getFontSize(),
          storeValue: fontSize,
          setStorage: _storage!.setFontSize,
          setStore: setFontSize);
      _sync<double>(
          storageValue: _storage!.getFontHeight(),
          storeValue: fontHeight,
          setStorage: _storage!.setFontHeight,
          setStore: setFontHeight);
      _sync<ThemeMode>(
          storageValue: _storage!.getTheme(),
          storeValue: theme,
          setStorage: _storage!.setTheme,
          setStore: setTheme);
    } catch (err) {
      Fluttertoast.showToast(msg: '設定檔同步錯誤: $err');
    }
  }

  void _sync<T>(
      {required T? storageValue,
      required T storeValue,
      required void Function(T val) setStorage,
      required void Function(T val) setStore}) {
    if (storageValue == null) {
      setStorage(storeValue);
    } else {
      setStore(storageValue);
    }
  }

  Future<void> save() async {
    try {
      await Future.wait([
        _storage!.setTheme(_theme),
        _storage!.setFontHeight(_fontHeight),
        _storage!.setFontSize(_fontSize)
      ]);
    } catch (err) {
      Fluttertoast.showToast(msg: '儲存設定發生錯誤: $err');
    }
  }

  setFontSize(double fontSize) {
    _fontSize = fontSize;
    notifyListeners();
  }

  setFontHeight(double fontHeight) {
    _fontHeight = fontHeight;
    notifyListeners();
  }

  setTheme(ThemeMode theme) {
    _theme = theme;
    notifyListeners();
  }

  toggleTheme() {
    _theme = _theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
