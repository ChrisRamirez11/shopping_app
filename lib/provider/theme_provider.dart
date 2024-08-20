import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  bool _themeData = true;

  bool get themeData => _themeData;

  ThemeProvider() {
    _loadTheme();
  }

  set themeData(bool themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  Future _loadTheme() async {
    final bool flag = prefs.darkMode;
    _themeData = flag;
    notifyListeners();
  }

  Future toggleTheme(value) async {
    _themeData = value;
    prefs.darkMode = themeData;
    _loadTheme();
    notifyListeners();
  }
}
