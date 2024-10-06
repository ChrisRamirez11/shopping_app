import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/models/shopping_list/ordered_product.dart';


class ShoppingListModel {
  List<CartItem> cartItems;

  ShoppingListModel({
    required this.cartItems
  });

  List<OrderedProduct> getOrder(){}
}