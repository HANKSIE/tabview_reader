import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/routes.dart';
import 'package:tabview_reader/store/settings.dart';
import 'package:tabview_reader/store/tabview_reader_group.dart';
import 'package:tabview_reader/views/tabview.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => TabviewReaderGroupStore()),
          ChangeNotifierProvider(create: (context) => SettingsStore()),
        ],
        child: Consumer<SettingsStore>(builder: (context, settings, child) {
          return MaterialApp(
            routes: routes,
            theme: ThemeData(
                brightness: Brightness.light, primarySwatch: Colors.teal),
            darkTheme: ThemeData(
                brightness: Brightness.dark, primarySwatch: Colors.teal),
            themeMode: settings.theme,
            debugShowCheckedModeBanner: false,
            home: const TabViewPage(),
          );
        }));
  }
}
