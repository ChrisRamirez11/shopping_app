import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsListNotifier extends ChangeNotifier {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  List<String> _productsListNotifier = [];

  List<String> get productsListNotifier => _productsListNotifier;

  ProductsListNotifier() {
    _loadList();
  }

  Future<void> _loadList() async {
    prefs.prefsProductsTypesList =
        await FetchingProductsTypes().productsTypesList();
    final List<String> list = prefs.prefsProductsTypesList;
    _productsListNotifier = list;
    notifyListeners();
  }

  Future<void> addItem(String item) async {
    _productsListNotifier.add(item);
    await _saveList();
    _loadList();
    notifyListeners();
  }

  Future<void> _saveList() async {
    prefs.prefsProductsTypesList = productsListNotifier;
    notifyListeners();
  }
}

//awesome
//
class FetchingProductsTypes {
  final supabase = Supabase.instance.client;
  List<String> types = [];

  Future<List<String>> productsTypesList() async {
    Future<List<Map<String, dynamic>>> response =
        supabase.from('products').select('type');

    final list = await response.then((value) => value.toList());

    for (var row in list) {
      types.add(row['type']);
    }

    return types.toSet().toList();
  }
}
