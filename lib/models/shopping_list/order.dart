import 'package:app_tienda_comida/models/shopping_list/ordered_product.dart';
import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import '../../main.dart';

class Order {
  int id;
  DateTime createdAt;
  String userId;
  List<Map<String, dynamic>> orderedProductsMap;
  double total;

  Order({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.orderedProductsMap,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        createdAt: json["created_at"],
        userId: json["user_id"],
        orderedProductsMap: json["products"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'products': orderedProductsMap, 'total': total};
}

class ShoppingListModel {
  Future<List<OrderedProduct>> getShoppingListOrder(List<CartItem> cartItems) async {
    List<OrderedProduct> orderedProducts = [];

    for (var cartItem in cartItems) {

      Product product = await fetchProduct(cartItem.productId);

      OrderedProduct orderedProduct = OrderedProduct(
          name: product.name,
          quantity: cartItem.quantity,
          price: product.price);
      orderedProducts.add(orderedProduct);
    }
    return orderedProducts;
  }

  Future<Product> fetchProduct(int productId) async {
    try {
      final response =
          await supabase.from('products').select().eq('id', productId).single();
      return Product.fromJson(response);
    } catch (e) {
      throw (e.toString());
      
    }
  }
}
