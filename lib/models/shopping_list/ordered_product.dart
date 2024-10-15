class OrderedProduct {
  String name;
  int quantity;
  double price;

  OrderedProduct({
    required this.name,
    required this.quantity,
    required this.price,
  });
  
  Map<String, dynamic> toJson() =>
      {"name": name, "quantity": quantity, "price": price};
}
