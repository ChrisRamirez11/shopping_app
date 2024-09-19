import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartSupabaseProvider {
  //TODO try catchs
  //addToCart
  //
  Future<void> addToCart(String userId, String productId, int quantity) async {
    final response = await supabase.from('carts').upsert(
        {'user_id': userId, 'product_id': productId, 'quantity': quantity},
        onConflict: 'product_id');
    print(response);
  }

  //updateCart
  /*
  aqui lo que pasa es que cada producto como es un cart a parte, 
  tendra por lo tanto un id de cart unico, entonces al actualizar dicho producto, 
  le pasas a este update el id del cart que tiene ese producto, es como sifuera
  un comprador con varios carritos para un solo producto por carro.
  */
  Future<void> updateCartItem(String cartId, int newQuantity) async {
    final response = await supabase
        .from('carts')
        .update({'quantity': newQuantity}).eq('id', cartId);

    print('$response');
  }

  Future<void> deleteCartItem(String cartId, int newQuantity) async {
    final response = await supabase.from('carts').delete().eq('id', cartId);

    print('$response');
  }

  //getCart
  //
  Future<List<CartItem>> getCart(String userId) async {
    try {
      final response = await supabase
          .from('carts')
          .select()
          .eq('user_id', userId)
          .order('id');
      return response.map((item) => CartItem.fromJson(item)).toList();
    } on AuthException catch (error) {
      print('Error fetching cart: ${error.message}');
      return [];
    } catch (e) {
      print('Error fetching cart: $e');
      return [];
    }
  }
}
