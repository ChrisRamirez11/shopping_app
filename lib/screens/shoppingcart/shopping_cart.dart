import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/provider/cart_supabase_provider.dart';
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
    final userId = supabase.auth.currentSession!.user.id;
    CartSupabaseProvider cartSupabaseProvider = CartSupabaseProvider();

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: FutureBuilder(
          future: cartSupabaseProvider.getCart(userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => getListTiles(data, index),
            );
          }),
    );
  }

  ListTile getListTiles(List<CartItem> cartsItems, int index) {
    return ListTile();
  }
}
