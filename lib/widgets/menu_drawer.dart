import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
    required this.primary,
  });

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
