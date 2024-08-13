import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/grid_view_widget.dart';
import 'package:app_tienda_comida/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class HomeSreen extends StatefulWidget {
  const HomeSreen({super.key});

  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: secondary,
        backgroundColor: primary,
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddProductSecreen(),
        )),
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Home Screen',
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
      drawer: MenuDrawer(primary: primary),
      body: GridViewWidget(),
    );
  }
}
