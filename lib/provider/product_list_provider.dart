import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class ProductsListNotifier extends ChangeNotifier {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  List<String> _productsListNotifier = [];

  List<String> get productsListNotifier => _productsListNotifier;

  ProductsListNotifier() {
    _loadList();
  }

  Future<void> _loadList() async {
    prefs.productsTypesList = await FetchingProductsTypes().productsTypesList();
    final List<String> list = prefs.productsTypesList;
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
    prefs.productsTypesList = productsListNotifier;
    notifyListeners();
  }
}

//awesome
//
class FetchingProductsTypes {
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
