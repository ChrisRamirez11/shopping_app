import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

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
              'Don Pepito',
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
                onTap: () {},
              ),
              Divider(
                endIndent: 5,
                indent: 5,
                height: 0,
              )
            ]);
          }).toList(),
        ],
      ),
    );
  }
}
