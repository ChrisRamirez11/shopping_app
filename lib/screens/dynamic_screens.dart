import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/screens/search_screen.dart';
import 'package:app_tienda_comida/screens/shoppingcart/shopping_cart.dart';
import 'package:app_tienda_comida/utils/account_validation.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/grid_view_widget.dart';
import 'package:app_tienda_comida/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class DynamicScreens extends StatefulWidget {
  final Map<String, dynamic> args;
  const DynamicScreens({super.key, required this.args});

  @override
  State<DynamicScreens> createState() => _DynamicScreensState();
}

class _DynamicScreensState extends State<DynamicScreens> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldDynKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: Scaffold(
        key: scaffoldDynKey,
        floatingActionButton: FloatingActionButton(
          foregroundColor: secondary,
          backgroundColor: primary,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddProductScreen(),
          )),
        ),
        appBar: AppBar(
          title: Text(
            widget.args['name'],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          foregroundColor: secondary,
          backgroundColor: primary,
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ));
              },
              icon: const Icon(Icons.search_outlined),
            ),
            IconButton(
              onPressed: () {
                if (!isAccountFinished(context)) {
                  return null;
                }
                scaffoldDynKey.currentState!.openEndDrawer();
              },
              icon: const Icon(
                IconData(0xe59c, fontFamily: 'MaterialIcons'),
              ),
            )
          ],
        ),
        endDrawer: const ShoppingCart(),
        drawer: MenuDrawer(appBarTitle: widget.args['name']),
        body: GridViewWidget(appBarTitle: widget.args['name']),
      ),
    );
  }
}
