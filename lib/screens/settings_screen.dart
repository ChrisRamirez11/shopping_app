import 'package:app_tienda_comida/provider/theme_provider.dart';
import 'package:app_tienda_comida/utils/theme.dart';
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
        appBar: AppBar(
          foregroundColor: secondary,
          backgroundColor: primary,
          title: Text(
            'Configuraciones',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
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
    bool darkMode = notifier.themeData;
    return SwitchListTile(
        thumbIcon: WidgetStatePropertyAll(
            darkMode ? Icon(Icons.dark_mode) : Icon(Icons.light_mode)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Modo Oscuro',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        value: flag,
        onChanged: (value) {
          setState(() {});
          notifier.toggleTheme(value);
        });
  }
}
