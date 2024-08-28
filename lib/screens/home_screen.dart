import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/grid_view_widget.dart';
import 'package:app_tienda_comida/widgets/menu_drawer.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';

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
    String appBarTitle = 'Inicio';
    return SafeArea(
      child: DoubleTapToExit(
        snackBar: const SnackBar(
          content: Text('Presione nuevamente para salir'),
          duration: Duration(milliseconds: 1000),
        ),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            foregroundColor: secondary,
            backgroundColor: primary,
            child: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            )),
          ),
          appBar: AppBar(
            title: Center(
              child: Text(
                appBarTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
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
          body: GridViewWidget(
            appBarTitle: appBarTitle,
          ),
        ),
      ),
    );
  }
}
