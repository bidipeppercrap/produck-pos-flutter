import 'package:flutter/material.dart';
import 'package:produck_pos/utils/db.dart';

import '../models/product.dart';
import '../utils/fetch.dart';

class ProductsStore {
  static List<Product> products = [];

  static Future<void> refreshProducts(BuildContext context, bool mounted) async {
    try {
      var products = await CustomFetch.fetchProduct();

      await DatabaseHelper.refreshProducts(products);

      ProductsStore.products = products;
    } catch (e) {
      var snackBar = const SnackBar(content: Text('Unable to fetch.'));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  static Future<void> resetProducts() async {
    await DatabaseHelper.reset();

    ProductsStore.products = [];
  }
}