import 'package:app_tienda_comida/provider/onHoverProvider.dart';
import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/utils/bloc/loginBloc/provider.dart';

import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenciasUsuario();
    return ProviderP(
      child: MultiProvider(
        providers: [
          
           ChangeNotifierProvider(
          create: (_) => OnHoverProvider(),
          lazy: false,
        ),
          ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'App Comida',
          theme: theme,
          home: HomeSreen(),
        ),
      ),
    );
  }
}

