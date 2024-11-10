import 'package:app_tienda_comida/provider/business_magement_selectedValue.dart';
import 'package:app_tienda_comida/provider/carrito_provider.dart';
import 'package:app_tienda_comida/screens/custom_error_screen.dart';
import 'package:app_tienda_comida/utils/consts.dart';
import 'package:app_tienda_comida/utils/notifications/local_notification.dart';
import 'package:app_tienda_comida/utils/refresh_token.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/services.dart';
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
      url: Consts.baseUrl,
      anonKey: Consts.anonKey,
      authOptions:
          const FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce));

  //TODO Eliminar para Users
  await initNotifications();
  listenToTableChanges();
  //*hasta aqui

  await refreshToken();

  ErrorWidget.builder = (FlutterErrorDetails details) =>
      CustomErrorScreen(errorMsg: details.exceptionAsString());

  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderP(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(
            create: (_) => ProductsListNotifier(),
          ),
          provider.ChangeNotifierProvider(create: (_) => ThemeProvider()),
          provider.ChangeNotifierProvider(create: (_) => SelectedValue()),
          provider.ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const MaterialAppFood.MaterialShopApp(),
      ),
    );
  }
}

class MaterialAppFood extends StatelessWidget {
  const MaterialAppFood.MaterialShopApp({
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
        home: const HomeScreen(),
        onGenerateRoute: (settings) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DynamicScreens(args: args),
          );
        });
  }
}
