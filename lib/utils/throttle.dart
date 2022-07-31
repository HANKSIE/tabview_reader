Function throttle(Function cb, int milliseconds) {
  DateTime? start;
  return () {
    final end = DateTime.now();
    if (start == null ||
        end.difference(start!).inMilliseconds >= milliseconds) {
      cb();
      start = DateTime.now();
    }
  };
}
