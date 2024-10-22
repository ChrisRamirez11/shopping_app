import 'package:app_tienda_comida/screens/no_stock/no_stock_grid_view_widget.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class NoStockProducts extends StatelessWidget {
  const NoStockProducts({super.key});

  @override
  Widget build(BuildContext context) {
    String appBarTitle = 'Sin Stock';
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          foregroundColor: secondary,
          backgroundColor: primary,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                IconData(0xe59c, fontFamily: 'MaterialIcons'),
              ),
            )
          ],
        ),
        drawer: MenuDrawer(appBarTitle: appBarTitle),
        body: NoStockGridViewWidget(
          appBarTitle: appBarTitle,
        ),
      ),
    );
  }
}
