import 'package:tabview_reader/utils/multi_condition_validation.dart';

class TabviewValidation {
  late final String _selects;
  late final String _keyword;
  TabviewValidation({required String selects, required String keyword}) {
    if (selects.length != 3) throw Exception('選項長度應為 3');
    _selects = selects;
    _keyword = keyword;
  }

  bool Function(Args) optionValidate(int order) {
    return (Args args) {
      if (args.options == null) return true;
      final selectOption = int.parse(_selects[order]);
      final option = int.parse(args.options![order]);
      return selectOption == option || selectOption == 0;
    };
  }

  bool _keywordValidateGuard(Args args) =>
      _selects == '000' || args.options != null;

  bool _keywordValidate(Args args) =>
      (_keyword.isEmpty && args.options == null) ||
      args.filename.toLowerCase().contains(_keyword.toLowerCase());

  bool exec(String filename) {
    final options = RegExp(r'=([0-5]{3})0.txt').firstMatch(filename)?.group(1);
    return MultiConditionValidation<Args>(validates: [
      ...[for (int i = 0; i < 3; i++) optionValidate(i)],
      _keywordValidateGuard,
      _keywordValidate,
    ]).exec(Args(filename: filename, options: options));
  }
}

class Args {
  String filename;
  String? options;
  Args({required this.filename, required this.options});
}
