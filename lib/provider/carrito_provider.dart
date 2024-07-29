import 'package:app_tienda_comida/models/Producto.dart';
import 'package:flutter/material.dart';

class Carrito extends ChangeNotifier{
List<Producto> productos=[];
Carrito();

 //TODO:Guardarlo localmente el carrito
addProducto(Producto producto){
  productos.add(producto);
 
  notifyListeners();
}
deleteProducto(Producto producto){
  productos.removeWhere((item) => item.id== producto.id);
  notifyListeners();
}
getTotal(){
  double total =0;
  productos.map(
(e) => total+=e.precio,
  );
}








}