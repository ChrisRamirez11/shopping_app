import 'package:app_tienda_comida/models/shopping_list/ordered_product.dart';

class Order {
  List<OrderedProduct> orderedProducts;
  double total;

  Order({
    required this.orderedProducts,
    required this.total
  });
}