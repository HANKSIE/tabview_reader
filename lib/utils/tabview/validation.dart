import 'package:tabview_reader/utils/multi_condition_validation.dart';

class TabviewValidation {
  late final String _selects;
  late final String _keyword;
  TabviewValidation({required String selects, required String keyword}) {
    if (selects.length != 4) throw Exception('選項長度應為 4');
    _selects = selects;
    _keyword = keyword;
  }

  bool Function(Args) optionValidate(int order) {
    return (Args args) {
      if (args.options == null) return true;
      final selectOption = int.parse(_selects[order]);
      final option = int.parse(args.options![order]);
      if (selectOption == 0) return true; // ignore
      return selectOption == option;
    };
  }

  bool _keywordValidate(Args args) => args.filename.contains(_keyword);

  exec(String filename) async {
    final options = RegExp(r'=([0-4]{4}).txt').firstMatch(filename)?.group(1);
    return MultiConditionValidation<Args>(
            validates: [
      [for (int i = 0; i < 5; i++) optionValidate(i)],
      [_keywordValidate]
    ].expand((element) => element).toList())
        .exec(Args(filename: filename, options: options));
  }
}

class Args {
  String filename;
  String? options;
  Args({required this.filename, required this.options});
}
