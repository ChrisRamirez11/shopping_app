import 'package:app_tienda_comida/models/producto.dart';
import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

bool hasStock(Product product) {
  if (!product.availability && product.quantity == 0) {
    return false;
  } else {
    return true;
  }
}

getTexts(String text, TextStyle? style){
  return Text(text, style: style,);
}
