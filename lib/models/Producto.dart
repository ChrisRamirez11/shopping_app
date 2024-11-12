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
  int quantity;
  String description;
  String pic;

  Product(
      {required this.id,
      required this.name,
      required this.type,
      required this.price,
      required this.availability,
      required this.quantity,
      required this.description,
      required this.pic});

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        price: double.parse(json["price"].toString()),
        availability: json["availability"],
        quantity: int.parse(json["quantity"].toString()),
        description: json["description"],
        pic: json["pic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "price": price,
        "availability": availability,
        "quantity": quantity,
        "description": description,
        "pic": pic
      };
}
