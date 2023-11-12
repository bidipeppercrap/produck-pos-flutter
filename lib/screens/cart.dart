import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:produck_pos/screens/product_catalog.dart';
import 'package:produck_pos/stores/cart_items.dart';
import 'package:produck_pos/utils/numbering.dart';
import 'package:produck_pos/widgets/cart_navigation.dart';
import 'package:produck_pos/widgets/number_field.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../stores/products.dart';
import '../widgets/main_drawer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int currentPageIndex = 0;

  void updateCurrentPageIndex(int newIndex) {
    setState(() {
      currentPageIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartItemStore(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('ProDuck - Point of Sale'),
        ),
        bottomNavigationBar: CartNavigation(onDestinationChange: (int newIndex) {
          updateCurrentPageIndex(newIndex);
        }),
        drawer: const MainDrawer(),
        body: <Widget>[
          Consumer<CartItemStore>(
            builder: (context, cart, child) {
              return CartView(
                addToCart: cart.addProductToCart,
                removeFromCart: cart.removeItem,
                setItemQty: cart.setItemQty,
                cartItems: cart.items,
                totalCartCost: cart.totalCost,
                totalCartPrice: cart.totalPrice,
                totalMargin: cart.totalMarginDisplayed,
              );
            },
          ),
          Consumer<CartItemStore>(
            builder: (context, cart, child) {
              return ProductCatalog(addToCart: cart.addProductToCart);
            },
          ),
          const Center(child: Text('Payment'),)
        ][currentPageIndex],
      ),
    );
  }
}

class CartView extends StatefulWidget {
  final Function addToCart;
  final Function removeFromCart;
  final Function setItemQty;
  final List<CartItem> cartItems;
  final double totalCartPrice;
  final double totalCartCost;
  final int totalMargin;

  const CartView({
    super.key,
    required this.addToCart,
    required this.removeFromCart,
    required this.setItemQty,
    required this.cartItems,
    required this.totalCartCost,
    required this.totalCartPrice,
    required this.totalMargin
  });

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  Future<void> _scanBarcode() async {
    String barcodeScanResult;

    try {
      barcodeScanResult = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);

      Product? productResult = ProductsStore.products.where((e) => e.barcode == barcodeScanResult).firstOrNull;
      if (productResult == null) {
        var snackBar = const SnackBar(content: Text('Product not found.'));

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      widget.addToCart(productResult);
    } on PlatformException {
      barcodeScanResult = 'Failed to get platform version.';
    }

    if (!mounted) return;
  }

  ListView cartList() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
        height: 1,
      ),
      itemCount: widget.cartItems.length,
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];

        final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
            minimumSize: const Size(32, 32)
        );

        return ExpansionTile(
          title: Text(item.name),
          subtitle: Text.rich(
              TextSpan(
                  text: '${item.qty} Units at ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: '${removeTrailingZeros(item.price)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)
                    )
                  ]
              )
          ),
          trailing: Text(removeTrailingZeros(item.price * item.qty)),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  NumberField(qty: item.qty, changeQty: (newQty) => widget.setItemQty(item, newQty),),
                  const Spacer(),
                  ElevatedButton(onPressed: () => widget.removeFromCart(item), style: buttonStyle, child: const Icon(Icons.delete, size: 16,))
                ],
              )
            )
          ],
        );
      },
    );
  }

  Expanded cartConditional() {
    if (widget.cartItems.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No product yet.'),
        ),
      );
    }

    return Expanded(
      child: cartList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        cartConditional(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text.rich(
                    textAlign: TextAlign.start,
                    TextSpan(
                        text: 'Total Price: ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: '${removeTrailingZeros(widget.totalCartPrice)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen)
                          )
                        ]
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text.rich(
                    textAlign: TextAlign.start,
                    TextSpan(
                        text: 'Total Cost: ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: '${removeTrailingZeros(widget.totalCartCost)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)
                          )
                        ]
                    ),
                  ),
                  Text.rich(
                    textAlign: TextAlign.start,
                    TextSpan(
                        text: 'Total Margin: ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: '${widget.totalMargin}%',
                              style: const TextStyle(fontWeight: FontWeight.bold)
                          )
                        ]
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: _scanBarcode,
                              style: ButtonStyle(
                                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)
                                      )
                                  )
                              ),
                              child: const Icon(Icons.qr_code_2)
                          )
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}