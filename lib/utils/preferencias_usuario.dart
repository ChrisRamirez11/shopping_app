import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();
  factory PreferenciasUsuario() {
    return _instancia;
  }
  PreferenciasUsuario._internal();
  late SharedPreferences _prefs;
  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set darkMode(bool value) {
    _prefs.setBool('ModoOscuro', value);
  }

  bool get darkMode {
    return _prefs.getBool('ModoOscuro') ?? false;
  }

  String get token {
    return _prefs.getString('Token') ?? '';
  }

  set token(String value) {
    _prefs.setString('Token', value);
  }

  String get user {
    return _prefs.getString('usuario') ?? '';
  }

  set user(String value) {
    _prefs.setString('usuario', value);
  }

  String get phoneNumber {
    return _prefs.getString('numero') ?? '';
  }

  set phoneNumber(String value) {
    _prefs.setString('numero', value);
  }

  List<String> get productsTypesList {
    return _prefs.getStringList('productsTypeList') ?? [];
  }

  set productsTypesList(List<String> value) {
    _prefs.setStringList('productsTypeList', value);
  }
}
