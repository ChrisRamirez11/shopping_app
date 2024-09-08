import 'package:app_tienda_comida/provider/onHoverProvider.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:provider/provider.dart' as provider;
import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/provider/theme_provider.dart';
import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/screens/dynamic_screens.dart';
import 'package:app_tienda_comida/utils/bloc/loginBloc/provider.dart';
import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lsohakpxtnsjxexmvdmj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxzb2hha3B4dG5zanhleG12ZG1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAxOTU5NDMsImV4cCI6MjAzNTc3MTk0M30.xNEhSXEPxqmEp72-N_poF5bIw7pCf36d8PZGih9avH8',
  );
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenciasUsuario();

    return ProviderP(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(
            create: (_) => OnHoverProvider(),
          ),
          provider.ChangeNotifierProvider(
            create: (_) => ProductsListNotifier(),
          ),
          provider.ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialAppFood(),
      ),
    );
  }
}

class MaterialAppFood extends StatelessWidget {
  const MaterialAppFood({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Comida',
        theme: provider.Provider.of<ThemeProvider>(context).themeData
            ? themeDark
            : theme,
        home: const HomeSreen(),
        onGenerateRoute: (settings) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DynamicScreens(args: args),
          );
        });
  }
}
