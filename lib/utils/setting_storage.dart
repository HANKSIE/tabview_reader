import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Setting { fontSize, fontHeight, themeDark, wakeUp, searchFolder }

extension ParseValueToString on Setting {
  String getValue() {
    return toString().split('.').last;
  }
}

class SettingStorage {
  late final SharedPreferences _prefs;

  SettingStorage(SharedPreferences prefs) {
    _prefs = prefs;
  }

  double? getFontSize() => _prefs.getDouble(Setting.fontSize.getValue());
  double? getFontHeight() => _prefs.getDouble(Setting.fontHeight.getValue());

  ThemeMode? getTheme() {
    var value = _prefs.getBool(Setting.themeDark.getValue());
    if (value == null) return null;
    return value ? ThemeMode.dark : ThemeMode.light;
  }

  bool? getWakeUp() => _prefs.getBool(Setting.wakeUp.getValue());

  String? getSearchFolder() =>
      _prefs.getString(Setting.searchFolder.getValue());

  Future<void> setFontSize(double val) =>
      _prefs.setDouble(Setting.fontSize.getValue(), val);
  Future<void> setFontHeight(double val) =>
      _prefs.setDouble(Setting.fontHeight.getValue(), val);
  Future<void> setTheme(ThemeMode theme) =>
      _prefs.setBool(Setting.themeDark.getValue(), theme == ThemeMode.dark);
  Future<void> setWakeUp(bool val) =>
      _prefs.setBool(Setting.wakeUp.getValue(), val);

  Future<void> setSearchFolder(String val) =>
      _prefs.setString(Setting.searchFolder.getValue(), val);
}
