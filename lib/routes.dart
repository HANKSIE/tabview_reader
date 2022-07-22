import 'package:flutter/widgets.dart';
import 'package:tabview_reader/views/search.dart';
import 'package:tabview_reader/views/search_result.dart';
import 'package:tabview_reader/views/tabview.dart';

Map<String, WidgetBuilder> routes = {
  '/tabview': (context) => const TabViewPage(),
  '/search': (context) => const SearchPage(),
  '/search/result': (context) => const SearchResultPage(),
};
