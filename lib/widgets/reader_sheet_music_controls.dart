import 'dart:developer';

import 'package:flutter/material.dart';

class TabviewReaderSheetMusicControls extends StatelessWidget {
  const TabviewReaderSheetMusicControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Tooltip(
        message: '上一首',
        child: IconButton(
            icon: const Icon(Icons.keyboard_double_arrow_left),
            onPressed: () {
              log('double left');
            }),
      ),
      Tooltip(
        message: '上一頁',
        child: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              log('left');
            }),
      ),
      Tooltip(
          message: '下一頁',
          child: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right),
            onPressed: () {
              log('right');
            },
          )),
      Tooltip(
          message: '下一首',
          child: IconButton(
            icon: const Icon(Icons.keyboard_double_arrow_right),
            onPressed: () {
              log('double right');
            },
          )),
    ]);
  }
}
