import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabview_reader/utils/setting_storage.dart';
import 'package:wakelock/wakelock.dart';

class SettingsStore with ChangeNotifier {
  double _fontSize = 8;
  ThemeMode _theme = ThemeMode.dark;
  bool _wakeUp = false;
  String _searchFolder = '';

  SettingStorage? _storage;
  get fontSize => _fontSize;
  final double fontHeight = 1.5;
  get lineHeight => _fontSize * fontHeight;
  get theme => _theme;
  get wakeUp => _wakeUp;
  get searchFolder => _searchFolder;
  get dark => _theme == ThemeMode.dark;

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
      _sync<ThemeMode>(
          storageValue: _storage!.getTheme(),
          storeValue: theme,
          setStorage: _storage!.setTheme,
          setStore: setTheme);
      _sync<bool>(
          storageValue: _storage!.getWakeUp(),
          storeValue: wakeUp,
          setStorage: _storage!.setWakeUp,
          setStore: setWakeUp);
      _sync<String>(
          storageValue: _storage!.getSearchFolder(),
          storeValue: searchFolder,
          setStorage: _storage!.setSearchFolder,
          setStore: setSearchFolder);
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

  Future<void> setFontSize(double fontSize) {
    _fontSize = fontSize;
    notifyListeners();
    return _storage!.setFontSize(_fontSize);
  }

  Future<void> setTheme(ThemeMode theme) {
    _theme = theme;
    notifyListeners();
    return _storage!.setTheme(_theme);
  }

  Future<void> setWakeUp(bool wakeUp) {
    _wakeUp = wakeUp;
    wakeUp ? Wakelock.enable() : Wakelock.disable();
    notifyListeners();
    return _storage!.setWakeUp(_wakeUp);
  }

  Future<void> setSearchFolder(String val) {
    _searchFolder = val;
    notifyListeners();
    return _storage!.setSearchFolder(_searchFolder);
  }

  toggleTheme() {
    setTheme(_theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    notifyListeners();
  }
}
