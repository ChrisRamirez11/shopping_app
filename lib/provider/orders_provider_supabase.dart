import 'package:app_tienda_comida/main.dart';
import 'package:flutter/material.dart';


Future<List<Map<String, dynamic>>> getOrder(BuildContext context) async {
  return await supabase.from('orders').select().order('id', ascending: false);
}
