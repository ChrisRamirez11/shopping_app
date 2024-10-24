import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/screens/account_relateds/redirect_screen.dart';
import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/screens/no_stock/no_stock_products.dart';
import 'package:app_tienda_comida/screens/orders_related/orders_screen.dart';
import 'package:app_tienda_comida/utils/account_validation.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../screens/favorites_screen.dart';
import '../screens/settings_screen.dart';

class MenuDrawer extends StatefulWidget {
  final String appBarTitle;
  const MenuDrawer({
    super.key,
    required this.appBarTitle,
  });

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    final productListNotifier = Provider.of<ProductsListNotifier>(context);
    final List<String> list = productListNotifier.productsListNotifier;
    final theme = Theme.of(context).textTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(color: primary),
            child: Center(
                child: Text(
              style: Theme.of(context).textTheme.labelLarge,
              'Menú',
            )),
          ),
          ListTile(
              leading: const Icon(Icons.home),
              title: getTexts('Inicio', theme.bodyMedium),
              onTap: () {
                if (!widget.appBarTitle.contains('Inicio')) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeSreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.pop(context);
                }
              }),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            endIndent: 5,
            indent: 5,
            height: 0,
          ),
          ...list.asMap().entries.map((entry) {
            String name = entry.value;
            return Column(children: [
              ListTile(
                leading: const Icon(Icons.local_mall_outlined),
                title: getTexts(name, theme.bodyMedium),
                onTap: () {
                  if (widget.appBarTitle.contains('Inicio')) {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamed(name, arguments: {'name': name});
                  } else {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushReplacementNamed(name, arguments: {'name': name});
                  }
                },
              ),
            ]);
          }).toList(),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            endIndent: 5,
            indent: 5,
            height: 0,
          ),
          //TODO: DELETE THIS FOR USERS
          ListTile(
              leading: const Icon(Icons.remove_shopping_cart_outlined),
              title: getTexts('Productos sin Stock', theme.bodyMedium),
              onTap: () {
                if (!isAccountFinished(context)) return;
                if (widget.appBarTitle.contains('Inicio')) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NoStockProducts(),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const NoStockProducts(),
                  ));
                }
              }),
          //hasta aqui

          ListTile(
              leading: const Icon(Icons.list_alt),
              title: getTexts('Pedidos', theme.bodyMedium),
              onTap: () {
                if (!isAccountFinished(context)) return;
                if (widget.appBarTitle.contains('Inicio')) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OrdersScreen(),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const OrdersScreen(),
                  ));
                }
              }),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            endIndent: 5,
            indent: 5,
            height: 0,
          ),
          /*
           ListTile(
               leading: const Icon(Icons.favorite),
               title: const Text('Favoritos'),
               onTap: () {
                 if (widget.appBarTitle.contains('Inicio')) {
                   Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => const FavoriteScreen(),
                   ));
                 } else {
                   Navigator.of(context).pushReplacement(MaterialPageRoute(
                     builder: (context) => const FavoriteScreen(),
                   ));
                 }
               }),
          */
          ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: getTexts('Perfil', theme.bodyMedium),
              onTap: () {
                if (widget.appBarTitle.contains('Inicio')) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RedirectScreen(),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const RedirectScreen(),
                  ));
                }
              }),
          ListTile(
              leading: const Icon(Icons.settings),
              title: getTexts('Configuraciones', theme.bodyMedium),
              onTap: () {
                if (widget.appBarTitle.contains('Inicio')) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ));
                }
              }),
        ],
      ),
    );
  }
}
