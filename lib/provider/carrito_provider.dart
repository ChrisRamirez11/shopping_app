import 'package:app_tienda_comida/models/Producto.dart';
import 'package:flutter/material.dart';

class Carrito extends ChangeNotifier {
  List<Product> productos = [];
  Carrito();

  //TODO:Guardarlo localmente el carrito
  addProducto(Product producto) {
    productos.add(producto);

    notifyListeners();
  }

  deleteProducto(Product producto) {
    productos.removeWhere((item) => item.id == producto.id);
    notifyListeners();
  }

  getTotal() {
    double total = 0;
    productos.map(
      (e) => total += e.precio,
    );
    return total;
  }
}
