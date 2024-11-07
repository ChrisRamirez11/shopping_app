import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/provider/cart_supabase_provider.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Carrito extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  final userId = supabase.auth.currentUser!.id;

  get cartItems => _cartItems;

  Carrito() {
    _loadCartItems();
  }

  _loadCartItems() async {
    _cartItems = await CartSupabaseProvider().getCart(userId);
    notifyListeners();
  }

  addCartItem(CartItem cartItem) {
    _cartItems.add(cartItem);
    notifyListeners();
  }


//! Velar si actualiza correctamente
  updateCartItem(CartItem cartItem) {
    final index = _cartItems.indexWhere((item) => item.id == cartItem.id);
    _cartItems
      ..removeAt(index)
      ..insert(index, cartItem);
    notifyListeners();
  }

  deleteCartItem(CartItem cartItem) {
    _cartItems.removeWhere((item) => item.id == cartItem.id);
    notifyListeners();
  }
}
