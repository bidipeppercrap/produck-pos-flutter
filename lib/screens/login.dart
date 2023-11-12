import 'package:flutter/material.dart';
import 'package:produck_pos/screens/cart.dart';
import 'package:produck_pos/stores/products.dart';
import 'package:produck_pos/utils/fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _serverController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server', _serverController.text);

    try {
      var token = await CustomFetch.getToken(_usernameController.text, _passwordController.text);
      await prefs.setString('token', token);
    } catch (e) {
      var snackBar = SnackBar(content: Text(e.toString()));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      if (!mounted) return;
      await ProductsStore.refreshProducts(context, mounted);
    } catch (e) {
      var snackBar = SnackBar(content: Text(e.toString()));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen())
    );
  }

  @override
  void dispose() {
    _serverController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Login')
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ServerField(controller: _serverController),
            UsernameField(controller: _usernameController),
            PasswordField(controller: _passwordController),
            ElevatedButton(onPressed: _login, child: const Text('Login'))
          ],
        )
    );
  }
}

class ServerField extends StatelessWidget {
  const ServerField({
    super.key,
    required this.controller
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Server'),
            const SizedBox(width: 25),
            Expanded(child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'http://192.168.1.2'
              ),
            ))
          ],
        )
    );
  }
}

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
    required this.controller
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Username'),
            const SizedBox(width: 25),
            Expanded(child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'root'
              ),
            ))
          ],
        )
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Password'),
            const SizedBox(width: 25),
            Expanded(child: TextFormField(
              obscureText: true,
              controller: controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password'
              ),
            ))
          ],
        )
    );
  }
}