import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/shoping_cart_map_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Map<String, dynamic>>? mapList;

  @override
  void dispose() {
    shoppingCartUpdating();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShopingCartMapListProvider cartProvider =
        Provider.of<ShopingCartMapListProvider>(context);

    // Initialize mapList
    mapList = cartProvider.mapList;

    List<Product> productsList = getProductList(mapList!);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: ListView.builder(
        itemCount: productsList.length,
        itemBuilder: (context, index) => getListTiles(productsList, index),
      ),
    );
  }

  ListTile getListTiles(List<Product> productsList, int index) {
    return ListTile();
  }

  void shoppingCartUpdating() {
    candela();
  }

  void candela() {
    ShopingCartMapListProvider cartProvider =
        Provider.of<ShopingCartMapListProvider>(context);
    cartProvider.updateMapList(mapList!);
  }
}

List<Product> getProductList(List<Map<String, dynamic>> mapList) {
  List<Product> products = [];
  for (int i = 0; i < mapList.length; i++) {
    final response = supabase
        .from('products')
        .select('*')
        .eq('id', mapList[i]['id'])
        .single();
    response.then(
      (value) => products.add(Product.fromJson(value)),
    );
  }
  return products;
}
