import 'package:flutter/material.dart';
import 'package:produck_pos/screens/cart.dart';
import 'package:produck_pos/screens/catalog.dart';
import 'package:produck_pos/screens/login.dart';
import 'package:produck_pos/screens/settings.dart';
import 'package:produck_pos/stores/products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  Future<void> _relog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('server');
    await ProductsStore.resetProducts();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (r) { return false; }
    );
  }

  Future<void> _refreshProducts() async {
    await ProductsStore.refreshProducts(context, mounted);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text('ProDuck - Point of Sale')),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen())
              );
            },
          ),
          ListTile(
            title: const Text('Products'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CatalogScreen())
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsRoute())
              );
            },
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(onPressed: _relog, child: const Text('Relog'))
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(onPressed: _refreshProducts, child: const Text('Refresh Products'))
          )
        ],
      ),
    );
  }
}