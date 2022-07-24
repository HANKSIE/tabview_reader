import 'package:tabview_reader/models/sheet_music.dart';

class TabviewReader {
  late final SheetMusic _sheetMusic;
  late int _viewLines;
  late num _viewHeight;
  int _pageIndex = 0;
  late List<List<String>> _pages;
  get page => _pages[_pageIndex];
  get pages => _pages;
  get viewLines => _viewLines;

  TabviewReader(
      {required num viewHeight,
      required num lineHeight,
      required SheetMusic sheetMusic}) {
    _sheetMusic = sheetMusic;
    _viewHeight = viewHeight;
    _viewLines =
        _computeViewLines(viewHeight: _viewHeight, lineHeight: lineHeight);
    _pages = _buildPages(sheetMusic: _sheetMusic, viewLines: _viewLines);
  }

  static _computeViewLines(
          {required num viewHeight, required num lineHeight}) =>
      (viewHeight / (lineHeight.ceil())).floor();

  void restart() {
    _pageIndex = 0;
  }

  void reset({num? viewHeight, required num lineHeight}) {
    _pageIndex = 0;
    if (viewHeight != null) {
      _viewHeight = viewHeight;
    }
    _viewLines =
        _computeViewLines(viewHeight: _viewHeight, lineHeight: lineHeight);

    _pages = _buildPages(sheetMusic: _sheetMusic, viewLines: _viewLines);
  }

  static List<List<String>> _buildPages(
      {required SheetMusic sheetMusic, required int viewLines}) {
    if (viewLines < 7) throw Exception('行高少於7');
    final lines = sheetMusic.lines;
    final heads = sheetMusic.heads;
    int start = 0;
    final List<List<String>> pages = [];

    if (heads[0] + 6 > viewLines - 1) {
      final prePageCount = heads[0] ~/ viewLines;
      final remain = heads[0] % viewLines;
      for (int j = 1; j <= prePageCount; j++) {
        pages.add([for (int k = start; k < viewLines * j; k++) lines[k]]);
        start = viewLines * j;
      }
      if (remain > 0) {
        pages.add([for (int j = start; j < start + remain; j++) lines[j]]);
      }
      start = heads[0];
    }

    for (int i = 1; i <= heads.length; i++) {
      if (i == heads.length) {
        final end = heads[i - 1] + 6;
        pages.add([for (int j = start; j <= end; j++) lines[j]]);
      } else if (heads[i] + 6 > start + viewLines - 1) {
        final end = heads[i - 1] + 6;
        pages.add([for (int j = start; j <= end; j++) lines[j]]);
        start = heads[i];
      }
    }
    return pages;
  }

  next() {
    if (_pageIndex == _pages.length - 1) return true;
    _pageIndex++;
    return false;
  }

  prev() {
    if (_pageIndex == 0) return true;
    _pageIndex--;
    return false;
  }
}
