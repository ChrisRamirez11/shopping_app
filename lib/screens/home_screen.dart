import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/grid_view_widget.dart';
import 'package:flutter/material.dart';

class HomeSreen extends StatefulWidget {
  const HomeSreen({super.key});

  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  Color primary = theme.primaryColor;
  Color secondary = theme.secondaryHeaderColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Container(
              child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_outlined),
          )),
          Container(
              child: IconButton(
            onPressed: () {},
            icon: Icon(
              IconData(0xe59c, fontFamily: 'MaterialIcons'),
            ),
          ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primary),
              child: Center(
                  child: Text(
                style: Theme.of(context).textTheme.headlineMedium,
                'Don Pepito',
              )),
            ),
            ListTile(
              title: Text('Opción 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Opción 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: GridViewWidget(),
    );
  }
}
