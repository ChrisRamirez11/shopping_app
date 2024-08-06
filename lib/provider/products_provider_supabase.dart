import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsProviderSupabase {
  final _client = Supabase.instance.client;

  final products =
      Supabase.instance.client.from('products').stream(primaryKey: ['id']);

  Future insertProduct(
      String name, String type, double price, bool availability) async {
    await _client.from('products').insert([
      {'name': name, 'type': type, 'price': price, 'availability': availability}
    ]);
  }

  Future updateProduct(
      int id, String name, String type, double price, bool availability) async {
    return _client.from('products').update({
      'name': name,
      'type': type,
      'price': price,
      'availability': availability
    }).eq('id', id);
  }

  Future deleteProduct(int id) async {
    return _client.from('products').delete().eq('id', id);
  }
}
