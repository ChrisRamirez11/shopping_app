import 'package:flutter/material.dart';

class ProductTypeValueProvider extends ChangeNotifier {
  String _productTypeValueProvider = '';

  String get productTypeValueProvider => _productTypeValueProvider;

  void changeValue(String s) {
    _productTypeValueProvider = s;
    notifyListeners();
  }
}
