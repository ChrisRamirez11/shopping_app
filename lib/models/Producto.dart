import 'dart:convert';

class ListarProductos {
  ListarProductos({
    required this.results,
  });

  List<Producto> results;

  factory ListarProductos.fromJson(String str) =>
      ListarProductos.fromMap(json.decode(str));

  factory ListarProductos.fromMap(List<dynamic> json) =>
      ListarProductos(
        results: List<Producto>.from(
            json.map((x) => Producto.fromJson(x))),
      );
}

class Producto {
  final int id;
  final String nombre;
  final String tipo;
  final double precio;
  final bool disponibilidad;
 

  Producto({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.precio,
    required this.disponibilidad,
  });

  factory Producto.fromRawJson(String str) =>
      Producto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Producto.fromJson(Map<String, dynamic> json) =>
      Producto(
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
