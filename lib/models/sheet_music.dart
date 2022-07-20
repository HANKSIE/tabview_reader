class SheetMusic {
  final List<int> heads;
  final List<String> lines;

  SheetMusic.fromJson(Map<String, dynamic> json)
      : heads = json['heads'],
        lines = json['lines'];
}
