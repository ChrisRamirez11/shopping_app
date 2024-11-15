import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/shopping_list/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersProviderSupabase {
  Future<List<Map<String, dynamic>>> getOrder() async {
    try {
      return await supabase.from('orders').select().order('id');
    } on AuthException catch (error) {
      throw error.message;
    } catch (error) {
      throw ('Ha ocurrido un error, vuelva a intentarlo. $error');
    }
  }

  Future<void> insertOrder(BuildContext context, Order order) async {
    try {
      return await supabase.from('orders').insert([order.toJson()]);
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

  Future<void> updateOrder(BuildContext context, int orderId) async {
    try {
      return await supabase
          .from('orders')
          .update({'attended': true}).eq('id', orderId);
    } on AuthException catch (error) {
      throw error.message;
    } catch (error) {
      throw 'Ha ocurrido un error, vuelva a intentarlo. $error';
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      return await supabase.from('orders').delete().eq('id', orderId);
    } on AuthException catch (error) {
      throw error.message;
    } catch (error) {
      throw 'Ha ocurrido un error, vuelva a intentarlo. $error';
    }
  }
}
