import 'package:tabview_reader/models/sheet_music.dart';

class TabViewReader {
  late final SheetMusic _sheetMusic;
  late final int _viewLines;
  int _page = 0;
  late List<List<String>> _pages;
  get page => _pages[_page];
  get pages => _pages;
  get viewLines => _viewLines;
  TabViewReader(
      {required int viewHeight,
      required int lineHeight,
      required SheetMusic sheetMusic}) {
    _sheetMusic = sheetMusic;
    _viewLines = (viewHeight / lineHeight).floor();
    _pages = _buildPages();
  }

  List<List<String>> _buildPages() {
    int start = 0;
    var lines = _sheetMusic.lines;
    var heads = _sheetMusic.heads;
    int p = 1;
    List<List<String>> pages = [];
    for (int i = 0; i <= heads.length; i++) {
      if (i == heads.length) {
        final end = heads[i - 1] + 6;
        pages.add([for (int j = start; j <= end; j++) lines[j]]);
      } else if (heads[i] + 6 > _viewLines * p - 1) {
        final end = heads[i - 1] + 6;
        pages.add([for (int j = start; j <= end; j++) lines[j]]);
        start = heads[i];
        p++;
      }
    }
    return pages;
  }

  next() {
    if (_page == _pages.length - 1) return true;
    _page++;
    return false;
  }

  prev() {
    if (_page == 0) return true;
    _page--;
    return false;
  }
}
