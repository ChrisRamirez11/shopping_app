import 'dart:math' as math;

import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/Producto.dart';
import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/models/shopping_list/order.dart';
import 'package:app_tienda_comida/provider/cart_supabase_provider.dart';
import 'package:app_tienda_comida/provider/orders_provider_supabase.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  double totalPrice = 0;
  final userId = supabase.auth.currentUser!.id;
  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    CartSupabaseProvider cartSupabaseProvider = CartSupabaseProvider();

    // Fetch cart items
    if (mounted) {
      cartItems = await cartSupabaseProvider.getCart(userId);
    }

    // Fetch products for all cart items
    if (mounted) {
      await fetchProductsForCartItems();
    }

    if (mounted) {
      setState(() {
        isLoading = false; // Set loading to false after fetching
      });
    }
  }

  Future<void> fetchProductsForCartItems() async {
    double totalPrice = 0;
    for (var item in cartItems!) {
      if (mounted) {
        final product = await fetchProduct(item.productId);
        productMap[item.productId] = product; // Store in map

        // Update totalPrice
        totalPrice += product.price * _getQuantity(item, product);
        if (item.quantity != _getQuantity(item, product)) {
          cartSupabaseProvider.updateCartItem(
              item.id, _getQuantity(item, product));
        }
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
        this.totalPrice = totalPrice;
      });
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
              children: [getTopBar(size), getListView(size), getTotals(size)],
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
    return Container(
      color: primary,
      height: size.height * 0.065,
      child: Center(
        child: Text(
          'Carrito',
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget getListTile(CartItem cartItem) {
    Product product = productMap[cartItem.productId]!; // Get product from map
    int quantity = _getQuantity(cartItem, product);
    final quantityController = TextEditingController.fromValue(TextEditingValue(
        text: quantity.toString(),
        selection: TextSelection(
            baseOffset: 0, extentOffset: quantity.toString().length)));

    return Card(
        elevation: 5,
        color: Theme.of(context).cardColor,
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
                flex: 2,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      IconButton(
                        iconSize: 24,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            double productPrice = product.price * quantity;

                            cartItems!.removeWhere(
                                (element) => element.id.contains(cartItem.id));

                            totalPrice -= productPrice;

                            cartSupabaseProvider.deleteCartItem(cartItem.id);
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: TextFormField(
                          controller: quantityController,
                          maxLength: 3,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.all(5),
                          ),
                          onChanged: (value) => quantityController.text = value,
                          onFieldSubmitted: (value) {
                            if (!isNumeric(value)) {
                              return;
                            }

                            int parsedValue = int.parse(value);

                            int limitedValue =
                                math.min(parsedValue, _getLimit(product));
                            if (limitedValue < 1) {
                              limitedValue = 1;
                            }

                            setState(() {
                              quantityController.text = limitedValue.toString();
                              quantity = limitedValue;
                              cartItem.quantity = quantity;
                              cartSupabaseProvider.updateCartItem(
                                  cartItem.id, quantity);
                              calculateNewTotal();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ]))
          ]),
        ));
  }

  getTotals(Size size) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: primary.withOpacity(0.7),
        ),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: RichText(
                text: TextSpan(
                  text: 'Total: ',
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: '\$',
                      children: [TextSpan(text: '$totalPrice')],
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: IconButton.filled(
                    style: const ButtonStyle(
                        iconSize: WidgetStatePropertyAll(40),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0))))),
                    onPressed: () async {
                      //*INSERT ORDER
                      final orderedProductsMap = await ShoppingListModel()
                          .getShoppingListOrder(cartItems!);
                      final resp = orderedProductsMap
                          .map(
                            (e) => e.toJson(),
                          )
                          .toList();
                      final order = Order(
                          id: 0,
                          createdAt: DateTime.now(),
                          userId: userId,
                          orderedProductsMap: resp,
                          total: totalPrice);
                      if (mounted) {
                        OrdersProviderSupabase().insertOrder(context, order);
                      }
                    },
                    icon: const Icon(
                        weight: 10, Icons.arrow_circle_right_outlined)))
          ],
        ),
      ),
    );
  }

  void calculateNewTotal() {
    double newTotalPrice = 0;
    for (var item in cartItems!) {
      final product = productMap[item.productId]!;
      newTotalPrice += product.price * item.quantity;
    }
    setState(() {
      totalPrice = newTotalPrice;
    });
  }

  int _getQuantity(CartItem cartItem, Product product) {
    int pQuantity = product.quantity;

    if (product.availability) {
      pQuantity = 100;
    }

    return cartItem.quantity > pQuantity ? pQuantity : cartItem.quantity;
  }
}

//functions
//
int _getLimit(Product product) {
  int limit;
  if (product.availability) {
    limit = 100;
  } else {
    limit = product.quantity;
  }
  return limit;
}

Future<Product> fetchProduct(int productId) async {
  try {
    final response =
        await supabase.from('products').select().eq('id', productId).single();
    return Product.fromJson(response);
  } on AuthException catch (error) {
    throw(error.toString());
  } catch (error) {
    throw('Error inseperado ocurrido ${error.toString()}');
  }
}

_loadImage(Product product) {
  if (product.pic.toString().isNotEmpty) {
    return CachedNetworkImage(
      cacheManager: null,
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
