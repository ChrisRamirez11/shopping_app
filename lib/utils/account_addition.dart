import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/cart_supabase_provider.dart';
import 'package:app_tienda_comida/utils/account_validation.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';

accountAddition(BuildContext context, Product product) {
  if (!isAccountFinished(context)) {
    return;
  }
  if (!hasStock(product)) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'ERROR',
                style:
                    TextStyle(color: errorColor, fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Producto Agotado',
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
    CartSupabaseProvider().addToCart(context,
        supabase.auth.currentSession!.user.id, product.id.toString(), 1);
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'Producto añadido con éxito',
                style: Theme.of(context).textTheme.titleMedium,
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
