import 'dart:math' as math;

import 'package:app_tienda_comida/models/cart_item_model.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/models/order.dart';
import 'package:app_tienda_comida/provider/carrito_provider.dart';
import 'package:app_tienda_comida/services/orders_provider_supabase.dart';
import 'package:app_tienda_comida/provider/theme_provider.dart';
import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:app_tienda_comida/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
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
    bool theme = Provider.of<ThemeProvider>(context).themeData;
    Map<int, Product> productMap = cartProvider.productMap;
    bool isLoading = cartProvider.isLoading;

    return Drawer(
      width: size.width * 0.80,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: theme ? second2 : null,
              child: Column(
                children: [
                  getTopBar(size),
                  getListView(
                      size, cartItemList, productMap, cartProvider, theme),
                  getTotals(size, cartItemList, cartProvider)
                ],
              ),
            ),
    );
  }

  Widget getListView(Size size, List<CartItem> cartItemList,
      Map<int, Product> productMap, CartProvider cartProvider, bool theme) {
    return SizedBox(
      height: size.height * 0.80,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        itemCount: cartItemList.length,
        itemBuilder: (context, index) =>
            getListTile(cartItemList[index], productMap, cartProvider, theme),
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
      CartProvider cartProvider, bool theme) {
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
                  const SizedBox(height: 5),
                  Text('\$${product.price}'),
                  const SizedBox(height: 5),
                  Text(
                    '#${product.type}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: theme ? greenCustom : Colors.green.shade900),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
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
                          maxLength: 4,
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
                            });
                            cartProvider.updateCartItem(cartItem);
                          },
                        ),
                      )
                    ],
                  ),
                ]))
          ]),
        ));
  }

  getTotals(Size size, List<CartItem> cartItemList, CartProvider cartProvider) {
    double total = cartProvider.total;
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
                    onPressed: () {
                      if (cartItemList.isEmpty) return null;
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: Center(child: Text('Realizar Compra')),
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Text(
                                  'Desea realizar la compra?\nEsta opciòn no es reversible',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: getTexts(
                                          'Cancelar',
                                          Theme.of(context)
                                              .textTheme
                                              .labelMedium)),
                                  Expanded(child: Container()),
                                  //
                                  //Order Generation
                                  TextButton(
                                      onPressed: () async {
                                        showUndismissibleDialog(
                                            context, 'Generando Compra');
                                        await cartProvider.getTotal();
                                        final orderedProductsMap =
                                            await ShoppingListModel()
                                                .getShoppingListOrder(
                                                    cartItemList);
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
                                        await cartProvider
                                            .deleteWholeCart(context);
                                        await OrdersProviderSupabase()
                                            .insertOrder(context, order);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        //TODO change below when we have the product provider change notifier
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: getTexts(
                                          'Ok',
                                          Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(color: primary))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
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
      pQuantity = 1000;
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
    return CustomImageWidget(imageUrl: product.pic);
  } else {
    return const Image(
      image: AssetImage('assets/images/no-image.png'),
    );
  }
}
