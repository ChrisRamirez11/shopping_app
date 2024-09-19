import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/provider/cart_supabase_provider.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  CartSupabaseProvider cartSupabaseProvider = CartSupabaseProvider();
  List<CartItem>? cartItems;
  Map<int, Product> productMap = {}; // Store products by their IDs
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final userId = supabase.auth.currentSession!.user.id;
    CartSupabaseProvider cartSupabaseProvider = CartSupabaseProvider();

    // Fetch cart items
    cartItems = await cartSupabaseProvider.getCart(userId);

    // Fetch products for all cart items
    await fetchProductsForCartItems();

    setState(() {
      isLoading = false; // Set loading to false after fetching
    });
  }

  Future<void> fetchProductsForCartItems() async {
    for (var item in cartItems!) {
      final product = await fetchProduct(item.productId);
      productMap[item.productId] = product; // Store in map
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Drawer(
      width: size.width * 0.80,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                getTopBar(size),
                getListView(size),
              ],
            ),
    );
  }

  Widget getListView(Size size) {
    return SizedBox(
      height: size.height * 0.80,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        itemCount: cartItems!.length,
        itemBuilder: (context, index) => getListTile(cartItems![index]),
      ),
    );
  }

  Widget getTopBar(Size size) {
    //TODO Edit this
    return Container(
      color: primary,
      height: size.height * 0.065,
      child: Center(
        child: Text(
          'Carrito',
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget getListTile(CartItem cartItem) {
    Product product = productMap[cartItem.productId]!; // Get product from map
    int quantity = cartItem.quantity;

    return Card(
        color: Theme.of(context).cardColor,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    SizedBox(width: 80, height: 80, child: _loadImage(product)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('\$${product.price}'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      IconButton(
                        iconSize: 24,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Implement delete functionality here
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      IconButton(
                        iconSize: 24,
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--; // Prevent negative quantity
                              cartItem.quantity =
                                  quantity; // Update CartItem quantity
                              cartSupabaseProvider.updateCartItem(
                                  cartItem.id, quantity);
                            }
                          });
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        iconSize: 24,
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++; // Increase quantity
                            cartItem.quantity =
                                quantity; // Update CartItem quantity
                            cartSupabaseProvider.updateCartItem(
                                cartItem.id, quantity);
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}

//functions
//

Future<Product> fetchProduct(int productId) async {
  final response =
      await supabase.from('products').select().eq('id', productId).single();
  return Product.fromJson(response);
}

_loadImage(Product product) {
  if (product.pic.toString().isNotEmpty) {
    return CachedNetworkImage(
      imageUrl: product.pic,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  } else {
    return const Image(
      image: AssetImage('assets/images/no-image.png'),
    );
  }
}
