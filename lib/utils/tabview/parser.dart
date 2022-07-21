import 'package:tabview_reader/models/sheet_music.dart';

class TabviewParser {
  static SheetMusic exec({required String name, required String content}) {
    try {
      var lineNo = _extract(content, 'LineNo').split(',');
      lineNo.removeLast();
      var lines = _extract(content, 'Tabs').split('\n');
      lines = lines.sublist(1, lines.length - 1);
      var sheetMusic = SheetMusic(
          name: name,
          heads: lineNo.map((ch) => int.parse(ch) - 2).toList(),
          lines: lines);
      if (!_validate(sheetMusic)) throw Exception('LineNo 或 Tabs 順序錯誤或空值');
      return sheetMusic;
    } catch (err) {
      throw Exception(err);
    }
  }

  static _validate(SheetMusic sheetMusic) {
    int prev = -1;
    var heads = sheetMusic.heads, lines = sheetMusic.lines;
    if (heads.isEmpty || lines.isEmpty) return false;
    for (int head in heads) {
      if (head < prev || head + 7 > lines.length) {
        return false;
      }
      prev = head;
    }
    return true;
  }

  static String _extract(String str, String tagName) {
    final start = '<$tagName>';
    final end = '</$tagName>';
    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end);
    if (startIndex == -1 || endIndex == -1) return '';
    return str.substring(startIndex + start.length, endIndex);
  }
}
