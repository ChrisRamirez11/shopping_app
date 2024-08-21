import 'package:app_tienda_comida/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ThemeProvider>(context);
    bool flag = notifier.themeData;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _createThemeSelector(flag, notifier),
            const Divider(
              endIndent: 5,
              indent: 5,
              height: 0,
            )
          ],
        ),
      ),
    );
  }

  _createThemeSelector(flag, ThemeProvider notifier) {
    return SwitchListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Tema Oscuro'),
        value: flag,
        onChanged: (value) {
          setState(() {});
          notifier.toggleTheme(value);
        });
  }
}
