import 'package:app_tienda_comida/models/producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsProviderSupabase {
  final _client = Supabase.instance.client;

  late final productsStream =
      _client.from('products').stream(primaryKey: ['id']);

//get Product
////////////////////////////////////////////////////////
  Stream<List<Map<String, dynamic>>> getProduct(
      BuildContext context, String from) {
    if (from == 'Home Screen') {
      try {
        return productsStream;
      } catch (e) {
        SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Ha ocurrido un error: Vuelva a cargar la pagina. $e')));
          },
        );
        return productsStream;
      }
    } else {
      try {
        return productsStream.eq('type', from);
      } catch (e) {
        SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Ha ocurrido un error: Vuelva a cargar la pagina. $e')));
          },
        );
        return const Stream.empty();
      }
    }
  }

//insert Product
////////////////////////////////////////////////////////
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

//update Product
////////////////////////////////////////////////////////
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

//delete Product
//////////////////////////////////////////////////////
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
