import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/screens/search_screen.dart';
import 'package:app_tienda_comida/screens/shoppingcart/shopping_cart.dart';
import 'package:app_tienda_comida/utils/account_validation.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/grid_view_widget.dart';
import 'package:app_tienda_comida/widgets/menu_drawer.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSreen extends StatefulWidget {
  const HomeSreen({super.key});

  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productListNotifier = Provider.of<ProductsListNotifier>(context);
    String appBarTitle = 'Inicio';
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: DoubleTapToExit(
        snackBar: const SnackBar(
          content: Text('Presione nuevamente para salir'),
          duration: Duration(milliseconds: 1000),
        ),
        child: Scaffold(
          key: scaffoldKey,
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
              'Recientes',
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
                    return;
                  }
                  scaffoldKey.currentState!.openEndDrawer();
                },
                icon: const Icon(
                  IconData(0xe59c, fontFamily: 'MaterialIcons'),
                ),
              )
            ],
          ),
          endDrawer: const ShoppingCart(),
          drawer: MenuDrawer(appBarTitle: appBarTitle),
          body: RefreshIndicator(
            onRefresh: () async => await productListNotifier.loadList(),
            child: GridViewWidget(
              appBarTitle: appBarTitle,
            ),
          ),
        ),
      ),
    );
  }
}
