import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/routes.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader.dart';
import 'package:tabview_reader/views/tabview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TabviewReaderStore()),
          ChangeNotifierProvider(create: (context) => SettingsStore()),
        ],
        child: MaterialApp(
          routes: routes,
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: const TabViewPage(),
        ));
  }
}
