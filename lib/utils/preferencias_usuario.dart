
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

  set modoOscuro(bool value) {
    _prefs.setBool('ModoOscuro', value);
  }

  bool get modoOscuro {
    return _prefs.getBool('ModoOscuro') ?? false;
  }
 String get token {
    return _prefs.getString('Token') ?? '';
  }

  set token(String value) {
    _prefs.setString('Token', value);
  }

  String get usuario {
    return _prefs.getString('usuario') ?? '';
  }

  set usuario(String value) {
    _prefs.setString('usuario', value);
  } 
 String get numero {
    return _prefs.getString('numero') ?? '';
  }

  set numero(String value) {
    _prefs.setString('numero', value);
  }
  
 
}
