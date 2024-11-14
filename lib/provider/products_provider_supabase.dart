import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsProviderSupabase {
  Future<List<Map<String, dynamic>>> productsStart(BuildContext context) async {
    try {
      return await supabase
          .from('products')
          .select()
          .order('id', ascending: false)
          .limit(10);
    } on AuthException catch (e) {
      SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Ha ocurrido un error: Vuelva a cargar la pagina. $e')));
        },
      );
      return [];
    } catch (e) {
      SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Ha ocurrido un error: Vuelva a cargar la pagina. $e')));
        },
      );
      return [];
    }
  }

//get Product
////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getProductByType(
      BuildContext context, String from) async {
    try {
      return await supabase.from('products').select().eq('type', from);
    } on AuthException catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      });
      return Future.value([{}]);
    } catch (e) {
      SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Ha ocurrido un error: Vuelva a cargar la pagina. $e')));
        },
      );
      return Future.value([{}]);
    }
  }

  Future<bool> productNameExists(BuildContext context, String value) async {
    try {
      var result = await (supabase.from('products').select().eq('name', value));
      return result.isNotEmpty;
    } on AuthException catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      });
      return false;
    } catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ha ocurrido un error, vuelva a intentarlo. $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      });
      return false;
    }
  }

//insert Product
////////////////////////////////////////////////////////
  Future<int> insertProduct(BuildContext context, Product product) async {
    try {
      final resp = await supabase
          .from('products')
          .insert({
            'name': product.name,
            'type': product.type,
            'price': product.price,
            'availability': product.availability,
            'pic': product.pic,
            'quantity': product.quantity,
            'description': product.description
          })
          .select()
          .single();
      return resp['id'];
    } on AuthException catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      });
      return 0;
    } catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ha ocurrido un error. $error')));
      });
      return 0;
    }
  }

//update Product
////////////////////////////////////////////////////////
  Future<void> updateProduct(BuildContext context, Product product) async {
    try {
      await supabase.from('products').update({
        'name': product.name,
        'type': product.type,
        'price': product.price,
        'availability': product.availability,
        'pic': product.pic,
        'quantity': product.quantity,
        'description': product.description
      }).eq('id', product.id);
    } on AuthException catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      });
    } catch (error) {
      throw 'Ha ocurrido un error, vuelva a intentarlo.';
    }
  }

//delete Product
//////////////////////////////////////////////////////
  Future<void> deleteProduct(BuildContext context, Product product) async {
    try {
      await supabase.from('products').delete().eq('id', product.id).then(
            (value) =>
                supabase.storage.from('pictures').remove(['${product.id}.png']),
          );
    } on AuthException catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      });
    } catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Ha ocurrido un error, vuelva a intentarlo. $error')));
      });
    }
  }

  Future<List<Map<String, dynamic>>> getEveryProduct() async {
    try {
      return await supabase.from('products').select();
    } on AuthException catch (error) {
      throw error.message;
    } catch (e) {
      throw 'Ha ocurrido un error. \n$e';
    }
  }
}
