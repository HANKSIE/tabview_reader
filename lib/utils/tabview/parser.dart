import 'package:tabview_reader/models/sheet_music.dart';

class TabviewParser {
  static SheetMusic exec(String str) {
    try {
      var lineNo = _extract(str, 'LineNo').split(',');
      lineNo.removeLast();
      var lines = _extract(str, 'Tabs').split('\n');
      lines = lines.sublist(1, lines.length - 1);
      return SheetMusic.fromJson({
        'heads': lineNo.map((ch) => int.parse(ch) - 2).toList(),
        'lines': lines
      });
    } catch (err) {
      throw Exception(err);
    }
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
