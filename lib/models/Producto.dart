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
  String name;
  String type;
  double price;
  bool availability;
  String pic;

  Product(
      {required this.id,
      required this.name,
      required this.type,
      required this.price,
      required this.availability,
      required this.pic});

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        availability: json["availability"],
        type: json["type"],
        pic: json["pic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "availability": availability,
        "type": type,
        "pic": pic
      };
}
