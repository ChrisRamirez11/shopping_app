import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/provider/cart_supabase_provider.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Carrito extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  CartSupabaseProvider cartSupabaseProvider = CartSupabaseProvider();

  final userId = supabase.auth.currentUser!.id;

  Carrito() {
    _loadCartItems();
  }

  _loadCartItems() async {
    _cartItems = await cartSupabaseProvider.getCart(userId);
    notifyListeners();
  }

  get cartItems => _cartItems;

  addCartItem(CartItem cartItem) {
    cartSupabaseProvider.addToCart(
        userId, cartItem.productId, cartItem.quantity);

    _cartItems.add(cartItem);

    notifyListeners();
  }

  //! Velar si actualiza correctamente
  updateCartItem(CartItem cartItem) {
    final index = _cartItems.indexWhere((item) => item.id == cartItem.id);

    cartSupabaseProvider.updateCartItem(cartItem.id, cartItem.quantity);

    _cartItems
      ..removeAt(index)
      ..insert(index, cartItem);

    notifyListeners();
  }

  deleteCartItem(CartItem cartItem) {
    _cartItems.removeWhere((item) => item.id == cartItem.id);

    cartSupabaseProvider.deleteCartItem(cartItem.id);

    notifyListeners();
  }
}
