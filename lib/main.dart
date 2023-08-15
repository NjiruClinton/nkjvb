import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'navigation.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bible App',
        theme: theme,
        darkTheme: darkTheme,
        home: NavigationTabs(),
      ),
    );
  }
}