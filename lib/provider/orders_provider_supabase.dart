import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/shopping_list/order.dart';
import 'package:flutter/material.dart';

class OrdersProviderSupabase {
  Future<List<Map<String, dynamic>>> getOrder(BuildContext context) async {
    return await supabase.from('orders').select().order('id');
  }

  Future<void> insertOrder(BuildContext context, Order order) {
    return supabase.from('orders').insert([
      {order}
    ]);
  }
}
