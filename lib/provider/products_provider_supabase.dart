import 'package:app_tienda_comida/models/producto.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsProviderSupabase {
  final _client = Supabase.instance.client;

  late final productsStream =
      _client.from('products').stream(primaryKey: ['id']);

  Stream<List<Map<String, dynamic>>> getProduct(
      BuildContext context, String from) {
    return productsStream;
  }

  Future<void> insertProduct(BuildContext context, Product product) async {
    try {
      await _client.from('products').insert([
        {
          'name': product.name,
          'type': product.type,
          'price': product.price,
          'availability': product.availability,
          'pic': product.pic
        }
      ]);
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ha ocurrido un error, vuelva a intentarlo')));
    }
  }

  Future<void> updateProduct(BuildContext context, Product product) async {
    try {
      await _client.from('products').update({
        'name': product.name,
        'type': product.type,
        'price': product.price,
        'availability': product.availability,
        'pic': product.pic
      }).eq('id', product.id);
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ha ocurrido un error, vuelva a intentarlo')));
    }
  }

  Future<void> deleteProduct(BuildContext context, int id) async {
    try {
      await _client.from('products').delete().eq('id', id);
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ha ocurrido un error, vuelva a intentarlo')));
    }
  }
}
