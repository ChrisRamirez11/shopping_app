import 'dart:developer';

import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartSupabaseProvider {
  //addToCart
  //
  Future<String> addToCart(String userId, int productId, int quantity) async {
    try {
      final resp = await supabase
          .from('carts')
          .insert({
            'user_id': userId,
            'product_id': productId,
            'quantity': quantity
          })
          .select()
          .single();
      return resp['id'];
    } on AuthException catch (e) {
      throw ('$e');
    } catch (e) {
      log('Ha ocurrido un error: $e');
      return '';
    }
  }

  //updateCart
  //
  Future<void> updateCartItem(String cartId, int newQuantity) async {
    try {
      final response = await supabase
          .from('carts')
          .update({'quantity': newQuantity}).eq('id', cartId);

      log('${response}updateCartItem');
    } on AuthException catch (e) {
      throw ('$e');
    } catch (e) {
      throw ('Ha ocurrido un error: $e');
    }
  }

  Future<void> deleteCartItem(String cartId) async {
    try {
      final response = await supabase.from('carts').delete().eq('id', cartId);
      log('${response}deletedCartItem');
    } on AuthException catch (e) {
      throw ('$e');
    } catch (e) {
      throw ('Ha ocurrido un error: $e');
    }
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
      throw ('Error fetching cart: ${error.message}');
    } catch (e) {
      throw ('Error fetching cart: $e');
    }
  }
}
