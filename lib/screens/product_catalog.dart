import 'package:flutter/material.dart';
import 'package:produck_pos/stores/products.dart';

import '../models/product.dart';
import '../utils/numbering.dart';
import '../widgets/pagination.dart';

class ProductCatalog extends StatefulWidget {
  final Function? addToCart;

  const ProductCatalog({
    super.key,
    this.addToCart
  });

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_handleSearchChange);

    WidgetsBinding.instance
      .addPostFrameCallback((timeStamp) { refreshProducts(); });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> products = ProductsStore.products.take(20).toList();
  int _currentPage = 1;
  int _totalPages = 1;

  void refreshProducts() {
    final query = _searchController.text;

    var keywords = query.trim().split(' ');
    Iterable<Product> whereQuery = ProductsStore.products;

    for (var word in keywords) {
      whereQuery = whereQuery.where((e) => e.name.toLowerCase().contains(word.toLowerCase()));
    }

    setState(() {
      products = whereQuery
          .skip((_currentPage - 1) * 20)
          .take(20)
          .toList();

      _totalPages = (whereQuery.length / 20).ceil();
    });
  }

  void _handleSearchChange() {
    setState(() {
      _currentPage = 1;
    });

    refreshProducts();
  }

  void _nextPageHandler() {
    setState(() {
      _currentPage++;
    });

    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) { refreshProducts(); });
  }

  void _prevPageHandler() {
    setState(() {
      _currentPage--;
    });

    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) { refreshProducts(); });
  }
  
  Product _getProductById(int id) {
    var product = ProductsStore.products.where((e) => e.id == id).first;
    
    return product;
  }

  Function? _onTapHandler(Product product) {
    if (widget.addToCart == null) return null;

    return widget.addToCart!(_getProductById(product.id));
  }

  Widget conditionalList() {
    if (products.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No product found.')
        )
      );
    }

    return Expanded(
      child: Column(
        children: [
          Expanded(child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              height: 1,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                title: Text(product.name),
                trailing: Text(removeTrailingZeros(product.price)),
                onTap: () => _onTapHandler(product),
              );
            },
          )),
          Pagination(
            currentPage: _currentPage,
            totalPages: _totalPages,
            prevPage: _prevPageHandler,
            nextPage: _nextPageHandler,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SearchField(controller: _searchController),
            )
          )
        ),
        conditionalList()
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
          hintText: 'Search...'
      ),
    );
  }
}