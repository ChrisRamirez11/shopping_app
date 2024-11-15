import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/carrito_provider.dart';
import 'package:app_tienda_comida/utils/account_validation.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';

cartAddition(BuildContext context, Product product, CartProvider cartProvider) {
  if (!isAccountFinished(context)) return;
  if (!hasStock(product)) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  'Producto Agotado',
                  style:
                      TextStyle(color: errorColor, fontWeight: FontWeight.bold),
                ),
              ),
              content: Text(
                'El producto se encuentra actualmente sin stock',
                style: TextStyle(color: errorColor, fontSize: 20),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'))
              ],
            ));

    return;
  } else {
    cartProvider.addCartItem(product);

    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'Producto añadido con éxito',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'))
              ],
            ));
  }
}
