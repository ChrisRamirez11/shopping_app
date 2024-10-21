import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsProviderSupabase {
  Future<List<Map<String, dynamic>>> productsStart(
      BuildContext context) async {
    try {
      return await supabase
          .from('products')
          .select()
          .order('id', ascending: false)
          .limit(10);
    } on AuthException catch (error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      });
      return Future.value([{}]);
    } catch (e) {throw 'Ha ocurrido un error: Vuelva a cargar la pagina. $e';
    
    }
  }

//get Product
////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getProduct(
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
  Future<void> insertProduct(BuildContext context, Product product) async {
    try {
      await supabase.from('products').insert([
        {
          'name': product.name,
          'type': product.type,
          'price': product.price,
          'availability': product.availability,
          'pic': product.pic,
          'quantity': product.quantity,
          'description': product.description
        }
      ]);
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
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Ha ocurrido un error, vuelva a intentarlo. $error')));
      });
    }
  }

//delete Product
//////////////////////////////////////////////////////
  Future<void> deleteProduct(BuildContext context, Product product) async {
    try {
      await supabase.from('products').delete().eq('id', product.id).then(
            (value) => supabase.storage
                .from('pictures')
                .remove(['${product.name}.png']),
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
}
