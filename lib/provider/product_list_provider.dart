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
