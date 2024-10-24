import 'package:app_tienda_comida/screens/orders_related/attended.dart';
import 'package:app_tienda_comida/screens/orders_related/unattended.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    String appBarTitle = 'Pedidos';
    return SafeArea(
      child: Scaffold(drawer: MenuDrawer(appBarTitle: appBarTitle),
        bottomNavigationBar: getBottomNavigatioBar(),
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          foregroundColor: secondary,
          backgroundColor: primary,
        ),
        body: callPage(currentIndex),
      ),
    );
  }

  getBottomNavigatioBar() {
    return BottomNavigationBar(currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Pendiente'),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rtl), label: 'Atendido'),
        ]);
  }

  callPage(int actualPage) {
    switch (actualPage) {
      case 0:
        return UnattendedOrder();
      case 1:
        return AttendedOrder();

      default:
        return UnattendedOrder();
    }
  }
}
