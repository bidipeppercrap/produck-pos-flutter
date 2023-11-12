import 'package:flutter/material.dart';
import 'package:produck_pos/screens/product_catalog.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: const ProductCatalog(addToCart: null,)
    );
  }
}