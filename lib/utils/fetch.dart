import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class CustomFetch {
  static Future<Uri> buildUrl(String route) async {
    final prefs = await SharedPreferences.getInstance();

    var baseUrl = prefs.getString('server') ?? '';

    return Uri.http(baseUrl, route);
  }

  static Future<String> getToken(String username, String password) async {
    Map<String, String> headers = { 'Content-Type': 'application/json' };
    final data = jsonEncode({
      'username': username,
      'password': password
    });

    var url = await buildUrl('login');
    var response = await http.post(url, headers: headers, body: data);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json['result'];
    } else if (response.statusCode == 400) {
      throw Exception('Incorrect password.');
    } else {
      throw Exception('Unknown error.');
    }
  }

  static Future<List<Product>> fetchProduct() async {
    final prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token') ?? '';
    Map<String, String> headers = { 'Content-Type': 'application/json', 'Authorization': 'Bearer $token' };

    var url = await buildUrl('products/all');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var productsJson = json['result'];

      List<Product> products = [];
      productsJson.forEach((product) => products.add(Product.fromJson(product)));

      return products;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthenticated.');
    } else {
      throw Exception('Failed to load products.');
    }
  }
}