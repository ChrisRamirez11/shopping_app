import 'package:app_tienda_comida/provider/onHoverProvider.dart';
import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/utils/bloc/loginBloc/provider.dart';

import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lsohakpxtnsjxexmvdmj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxzb2hha3B4dG5zanhleG12ZG1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAxOTU5NDMsImV4cCI6MjAzNTc3MTk0M30.xNEhSXEPxqmEp72-N_poF5bIw7pCf36d8PZGih9avH8',
  );
  // final prefs = PreferenciasUsuario();
  // await prefs.initPrefs();
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
