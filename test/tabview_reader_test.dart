import 'package:collection/collection.dart';
import 'package:tabview_reader/models/sheet_music.dart';
import 'package:tabview_reader/utils/tabview/reader.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('tab view build page test.', () {
    var reader = TabviewReader(
        viewHeight: 64,
        lineHeight: 4,
        sheetMusic: SheetMusic(
            name: 'papaya',
            heads: [2, 11, 18, 29],
            lines: [for (var i = 0; i <= 50; i++) '$i']));
    expect(reader.viewLines, 16);
    expect(
        const DeepCollectionEquality().equals(reader.pages, [
          [for (var i = 2; i <= 8; i++) '$i'],
          [for (var i = 11; i <= 24; i++) '$i'],
          [for (var i = 29; i <= 35; i++) '$i'],
        ]),
        true);
  });
}
