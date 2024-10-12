
import 'package:app_tienda_comida/main.dart';
import 'package:flutter/material.dart';


dynamic getOrder(BuildContext context) async {
  final userId = supabase.auth.currentUser!.id;
  final role = await supabase.from('profiles').select().eq('id', userId).single();
  return getOrderByRole(role['role'], userId);
}

Future<List<Map<String, dynamic>>> getOrderByRole(String role, String userId) async {
  if(role == 'admin'){
    return await supabase.from('orders').select().order('id', ascending: false);
  }else{
    return await supabase.from('orders').select().eq('userId', userId);
  }
}