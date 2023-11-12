import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartItemStore extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_cartItems);

  double get totalPrice => _cartItems.fold(0, (previousValue, element) => previousValue + (element.qty * element.price));
  double get totalCost => _cartItems.fold(0, (previousValue, element) => previousValue + (element.qty * element.cost));
  double get totalProfit => totalPrice - totalCost;
  double get totalMargin => totalProfit <= 0 ? (totalProfit / totalCost) * 100 : (totalProfit / totalPrice) * 100;
  int get totalMarginDisplayed => totalMargin.isNaN ? 0 : totalMargin.floor();

  void setItemQty(CartItem item, int qty) {
    item.qty = qty;

    notifyListeners();
  }

  void removeItem(CartItem item) {
    _cartItems.remove(item);

    notifyListeners();
  }

  void addProductToCart(Product product) {
    var currentProduct = _cartItems.where((e) => e.barcode == product.barcode).firstOrNull;

    if (currentProduct == null) {
      CartItem newItem = CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          cost: product.cost,
          barcode: product.barcode,
          qty: 1
      );

      _cartItems.add(newItem);
    } else {
      currentProduct.qty++;
    }

    notifyListeners();
  }

  void reset() {
    _cartItems.clear();

    notifyListeners();
  }
}