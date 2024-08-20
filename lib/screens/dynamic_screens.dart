import 'package:app_tienda_comida/screens/add_product_screen.dart';
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
    return SafeArea(
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
              widget.args['name'],
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
        drawer: MenuDrawer(appBarTitle: widget.args['name']),
        body: GridViewWidget(appBarTitle: widget.args['name']),
      ),
    );
  }
}
