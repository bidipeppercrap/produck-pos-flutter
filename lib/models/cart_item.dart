import 'package:produck_pos/models/product.dart';

class CartItem extends Product {
  int qty;

  CartItem({
    required int id,
    required String name,
    required double price,
    required double cost,
    required String barcode,
    this.qty = 1
  }) : super(id: id, name: name, price: price, cost: cost, barcode: barcode);
}