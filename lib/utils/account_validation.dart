import 'package:app_tienda_comida/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

bool isAccountFinished(BuildContext context) {
  try {
    final session = supabase.auth.currentSession;
    if (session == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Debe registrarse')));
      return false;
    } else {
      //TODO arreglar es ver por el name en profiles
      final userId = supabase.auth.currentSession!.user.id;
      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Debe terminar de rellenar los datos de su perfil')));
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
