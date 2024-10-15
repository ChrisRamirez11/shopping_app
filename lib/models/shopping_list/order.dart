import 'package:app_tienda_comida/models/shopping_list/ordered_product.dart';
import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import '../../main.dart';
class Order {
  int id;
  String userId;
  Map<int, Map<String, dynamic>> orderedProductsMap;
  double total;

  Order({
    required this.id,
    required this.userId,
    required this.orderedProductsMap,
    required this.total,
  });

  Map<String, dynamic> toJson()=>{
    // TODO check orders supabase to know yhe columns names
    'id':id,
    'user_id':userId,
    'orderedProduct': orderedProductsMap,
    'total': total
  };
 }


class ShoppingListModel {
  List<CartItem> cartItems;

  ShoppingListModel({
    required this.cartItems
  });
  List<OrderedProduct> getOrder(){
    List<OrderedProduct> orderedProducts = [];
    cartItems.map((e) async {
      Product product = await fetchProduct(e.productId);
      OrderedProduct orderedProduct = OrderedProduct(name: product.name, quantity: e.quantity, price: product.price);
      orderedProducts.add(orderedProduct);
    },);
    return orderedProducts;
  }

  Future<Product> fetchProduct(int productId) async{
    final response = await
    supabase.from('products').select('name').eq('id', productId).single();
    return Product.fromJson(response);
  }
}