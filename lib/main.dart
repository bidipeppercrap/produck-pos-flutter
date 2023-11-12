import 'package:flutter/material.dart';
import 'package:produck_pos/screens/cart.dart';
import 'package:produck_pos/screens/login.dart';
import 'package:produck_pos/stores/products.dart';
import 'package:produck_pos/utils/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class ServerWrapper extends StatelessWidget {
  const ServerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final prefs = snapshot.data as SharedPreferences;
              final token = prefs.getString('token') ?? '';

              if (token.isEmpty) { return const LoginScreen(); }
              else { return const RefreshWrapper(); }
            }
            else {
              return const LoginScreen();
            }
          }
          else {
            return const CircularProgressIndicator();
          }
    });
  }
}

class RefreshWrapper extends StatelessWidget {
  const RefreshWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ProductsStore.refreshProducts(context, context.mounted),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const DatabaseWrapper();
          }
          else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}

class DatabaseWrapper extends StatelessWidget {
  const DatabaseWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.products(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final products = snapshot.data as List<Product>;

            ProductsStore.products = products;
          }
          else {
            ProductsStore.products = [];
          }

          return const CartScreen();
        }
        else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProDuck PoS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ServerWrapper()
    );
  }
}
