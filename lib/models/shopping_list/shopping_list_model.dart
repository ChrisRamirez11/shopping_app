import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/models/shopping_list/ordered_product.dart';
import '../../main.dart';


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