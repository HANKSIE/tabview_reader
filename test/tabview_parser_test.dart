import 'package:collection/collection.dart';
import 'package:tabview_reader/utils/tabview/parser.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  List<int> lineNo = [12, 20, 28, 36];
  var content = '''
    <LineNo>${lineNo.join(',')},</LineNo>
    <Tabs>${[for (var i = 0; i <= 50; i++) '\n$i'].join('')}\n</Tabs>
    ''';
  final listEq = const ListEquality().equals;
  test('tab view parser response validate.', () {
    var name = 'papaya';
    var sheetMusic = TabviewParser.exec(name: name, content: content);
    expect(sheetMusic.name, name);
    expect(
        listEq(sheetMusic.heads, lineNo.map((val) => val - 2).toList()), true);
    expect(
        listEq(sheetMusic.lines, [for (var i = 0; i <= 50; i++) '$i']), true);
  });

  //TODO test parse wrong data
}
