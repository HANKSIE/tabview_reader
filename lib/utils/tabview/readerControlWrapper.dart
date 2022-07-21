import 'package:fluttertoast/fluttertoast.dart';

void Function() readerControlWrapper(
    {required bool Function() target, required String doneTip}) {
  return () {
    var isDone = target();
    if (isDone) {
      Fluttertoast.showToast(msg: doneTip, gravity: ToastGravity.CENTER);
    }
  };
}
