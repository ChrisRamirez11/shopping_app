import 'dart:math' as math;

import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/models/shopping_list/order.dart';
import 'package:app_tienda_comida/provider/carrito_provider.dart';
import 'package:app_tienda_comida/provider/orders_provider_supabase.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool isLoading = true; // Loading state

  final userId = supabase.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    List<CartItem> cartItemList = cartProvider.cartItems;
    double total = cartProvider.getTotal();

    Map<int, Product> productMap = cartProvider.productMap;

    return Drawer(
      width: size.width * 0.80,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                getTopBar(size),
                getListView(size, cartItemList, productMap, cartProvider),
                getTotals(size, cartItemList, total)
              ],
            ),
    );
  }

  Widget getListView(Size size, List<CartItem> cartItemList,
      Map<int, Product> productMap, CartProvider cartProvider) {
    return SizedBox(
      height: size.height * 0.80,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        itemCount: cartItemList.length,
        itemBuilder: (context, index) =>
            getListTile(cartItemList[index], productMap, cartProvider),
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

  Widget getListTile(CartItem cartItem, Map<int, Product> productMap,
      CartProvider cartProvider) {
    Product product = productMap[cartItem.productId]!;
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
                          cartProvider.deleteCartItem(cartItem);
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
                          style: Theme.of(context).textTheme.bodyMedium,
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
                              cartProvider.updateCartItem(cartItem);
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

  getTotals(Size size, List<CartItem> cartItemList, double total) {
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
                      children: [TextSpan(text: '$total')],
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
                          .getShoppingListOrder(cartItemList);
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
                          total: total);
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

_loadImage(Product product) {
  if (product.pic.toString().isNotEmpty) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
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
