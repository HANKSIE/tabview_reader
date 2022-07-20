import 'package:collection/collection.dart';
import 'package:tabview_reader/utils/tabview/parser.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  List<int> lineNo = [12, 20, 28, 36];
  var str = '''
    <LineNo>${lineNo.join(',')},</LineNo>
    <Tabs>\n123\n456\n789\n</Tabs>
    ''';
  final listEq = const ListEquality().equals;
  test('tab view parser response validate.', () {
    var res = TabviewParser.exec(str);
    expect(listEq(res.heads, lineNo.map((val) => val - 2).toList()), true);
    expect(listEq(res.lines, ['123', '456', '789']), true);
  });
}
