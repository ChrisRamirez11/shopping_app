import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/screens/account_relateds/redirect_screen.dart';
import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

bool isAccountFinished(BuildContext context) {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  try {
    final session = supabase.auth.currentSession;
    if (session == null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RedirectScreen(),
      ));
      return false;
    } else {
      //TODO Comprobar todo el tema de prefs y tal
      final userName = prefs.user;
      final userPhone = prefs.phoneNumber;
      if (userName.isEmpty || userPhone.isEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RedirectScreen(),
        ));
        return false;
      }
    }
  } on AuthException catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));

    return false;
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error inesperado $e')));
  }
  return true;
}
