import 'package:app_tienda_comida/screens/register_screen.dart';
import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   PreferenciasUsuario prefs = PreferenciasUsuario();
   bool  registered(){
    return prefs.usuario != '';
   }
    return MaterialApp(
      title: 'App Comida',
      theme:theme, 
      home:  registered()?RegisterScreen() :Container(),
    );
  }
}

