import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/settings.dart';

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
              style: Theme.of(context).textTheme.headlineMedium,
              'Menú',
            )),
          ),
          const Divider(
            height: 0,
          ),
          ...list.asMap().entries.map((entry) {
            String name = entry.value;
            return Column(children: [
              ListTile(
                title: Text(name),
                onTap: () {
                  if (widget.appBarTitle.contains('Home Screen')) {
                    Navigator.of(context)
                        .pushNamed(name, arguments: {'name': name});
                  } else {
                    Navigator.of(context)
                        .pushReplacementNamed(name, arguments: {'name': name});
                  }
                },
              ),
              const Divider(
                endIndent: 5,
                indent: 5,
                height: 0,
              )
            ]);
          }).toList(),
          ListTile(
            title: const Text('Configuraciones'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Settings(),
            )),
          )
        ],
      ),
    );
  }
}
