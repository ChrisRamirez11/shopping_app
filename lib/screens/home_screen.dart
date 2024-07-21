import 'package:app_tienda_comida/utils/theme.dart';
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
        backgroundColor: primary,
      ),
      drawer: Drawer(
        backgroundColor: secondary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primary),
              child: Center(
                  child: Text(
                style: Theme.of(context).textTheme.headlineMedium,
                'Productos',
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
      body: Center(),
    );
  }
}
