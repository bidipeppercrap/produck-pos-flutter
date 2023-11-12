class Product {
  final int id;
  final String name;
  final double price;
  final double cost;
  final String barcode;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.cost,
    required this.barcode
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'cost': cost,
      'barcode': barcode
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, cost: $cost, barcode: $barcode}';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    var newBarcode = json['barcode'] ?? '';
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as double,
      cost: json['cost'] as double,
      barcode: newBarcode as String
    );
  }
}