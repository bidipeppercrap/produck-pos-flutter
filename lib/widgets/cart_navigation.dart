import 'package:flutter/material.dart';

typedef PageIndexCallback = void Function(int index);

class CartNavigation extends StatefulWidget {
  const CartNavigation({super.key, required this.onDestinationChange});

  final PageIndexCallback onDestinationChange;

  @override
  State<CartNavigation> createState() => _CartNavigationState();
}

class _CartNavigationState extends State<CartNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.trolley), label: 'Cart'),
        NavigationDestination(icon: Icon(Icons.apps), label: 'Products'),
        NavigationDestination(icon: Icon(Icons.payment), label: 'Payment')
      ],
      onDestinationSelected: (int index) async {
        widget.onDestinationChange(index);
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
    );
  }
}