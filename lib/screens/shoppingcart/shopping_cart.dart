import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Map<String, dynamic>>? mapList;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List list = [];

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => getListTiles(list, index),
      ),
    );
  }

  ListTile getListTiles(List productsList, int index) {
    return ListTile();
  }
}
