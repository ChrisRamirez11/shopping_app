import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/cart_supabase_provider.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  CartSupabaseProvider _cartSupabaseProvider = CartSupabaseProvider();
  Map<int, Product> _productMap = {};
  double total = 0;
  bool isLoading = true;

  final userId = supabase.auth.currentUser!.id;

  CartProvider() {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    _cartItems = await _cartSupabaseProvider.getCart(userId);
    await _fetchProductsForCartItems();
    await getTotal();
    isLoading = false;
    notifyListeners();
  }

  List<CartItem> get cartItems => _cartItems;
  Map<int, Product> get productMap => _productMap;

  addCartItem(Product product) async {
    CartItem cartItem =
        CartItem(id: '', userId: userId, productId: product.id, quantity: 1);
    await _cartSupabaseProvider.addToCart(userId, product.id, 1);

    _productMap[product.id] = product;
    _cartItems.add(cartItem);
    notifyListeners();
  }

  updateCartItem(CartItem cartItem) async {
    final index = _cartItems.indexWhere((item) => item.id == cartItem.id);

    await _cartSupabaseProvider.updateCartItem(cartItem.id, cartItem.quantity);

    _cartItems
      ..removeAt(index)
      ..insert(index, cartItem);

    notifyListeners();
  }

  deleteCartItem(CartItem cartItem) async {
    await _cartSupabaseProvider.deleteCartItem(cartItem.id);
    _cartItems.removeWhere((item) => item.id == cartItem.id);

    notifyListeners();
  }

  Future<void> getTotal() async {
    double localTotal = 0;
    for (var cartItem in _cartItems) {
      localTotal +=
          (_productMap[cartItem.productId]?.price ?? 0 * cartItem.quantity);
    }
    total = localTotal;
    notifyListeners();
  }

  ///////////////////////////////////////////
  //Products Fetching
  Future<void> _fetchProductsForCartItems() async {
    _productMap.clear();
    for (var item in _cartItems) {
      final product = await _fetchProduct(item.productId);
      _productMap[item.productId] = product;
    }
    notifyListeners();
  }

  Future<Product> _fetchProduct(int productId) async {
    try {
      final response =
          await supabase.from('products').select().eq('id', productId).single();
      return Product.fromJson(response);
    } on AuthException catch (error) {
      throw (error.toString());
    } catch (error) {
      throw ('Error inseperado ocurrido ${error.toString()}');
    }
  }
}
