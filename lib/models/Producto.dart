import 'dart:convert';

class ListarProductos {
  ListarProductos({
    required this.results,
  });

  List<Product> results;

  factory ListarProductos.fromJson(String str) =>
      ListarProductos.fromMap(json.decode(str));

  factory ListarProductos.fromMap(List<dynamic> json) => ListarProductos(
        results: List<Product>.from(json.map((x) => Product.fromJson(x))),
      );
}

class Product {
  int id;
  String nombre;
  String tipo;
  double precio;
  bool disponibilidad;

  Product({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.precio,
    required this.disponibilidad,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        nombre: json["nombre"],
        precio: json["precio"],
        disponibilidad: json["disponibilidad"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio": precio,
        "disponibilidad": disponibilidad,
        "tipo": tipo,
      };
}
