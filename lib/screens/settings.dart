import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  void _toggleDarkMode() {
    AdaptiveTheme.of(context).toggleThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
              onChanged: (value) {
                _toggleDarkMode();
              },
            ),
            Text('Dark Mode'),
          ],
        ),
      ),
    );
  }
}