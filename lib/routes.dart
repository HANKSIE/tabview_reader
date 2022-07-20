import 'package:flutter/widgets.dart';
import 'package:tabview_reader/views/search.dart';
import 'package:tabview_reader/views/tabview.dart';

Map<String, WidgetBuilder> routes = {
  '/tabview': (_) => const TabViewPage(),
  '/search': (_) => const SearchPage(),
};
