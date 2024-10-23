import 'dart:developer';

import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartSupabaseProvider {
  //addToCart
  //
  Future<void> addToCart(BuildContext context, String userId, String productId,
      int quantity) async {
    try {
      await supabase.from('carts').insert(
          {'user_id': userId, 'product_id': productId, 'quantity': quantity});
    } on AuthException catch (e) {
      log('$e');
    } catch (e) {
      log('Ha ocurrido un error: $e');
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
      log('$e');
    } catch (e) {
      log('Ha ocurrido un error: $e');
    }
  }

  Future<void> deleteCartItem(String cartId) async {
    try {
      final response = await supabase.from('carts').delete().eq('id', cartId);
      log('${response}updateCartItem');
    } on AuthException catch (e) {
      log('$e');
    } catch (e) {
      log('Ha ocurrido un error: $e');
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
      print('Error fetching cart: ${error.message}');
      return [];
    } catch (e) {
      print('Error fetching cart: $e');
      return [];
    }
  }
}
