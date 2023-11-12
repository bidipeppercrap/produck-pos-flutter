import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';

class DatabaseHelper {
  static Future<void> reset() async {
    final db = await DatabaseHelper.database;
    db.close();

    databaseFactory.deleteDatabase(join(await getDatabasesPath(), 'produck.db'));

    DatabaseHelper.database = DatabaseHelper.connect();
  }

  static Future<Database> connect() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'produck.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL,
            cost REAL,
            barcode TEXT
          )
          '''
        );
      },
      version: 1,
    );

    return database;
  }

  static Future<Database> database = DatabaseHelper.connect();

  static Future<void> refreshProducts(List<Product> products) async {
    await DatabaseHelper.reset();
    await DatabaseHelper.insertBulkProduct(products);
  }

  static Future<void> insertBulkProduct(List<Product> products) async {
    final db = await database;
    final batch = db.batch();

    for (final p in products) {
      batch.insert(
        'products',
        p.toMap()
      );
    }

    await batch.commit();
  }

  static Future<List<Product>> products() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        price: maps[i]['price'] as double,
        cost: maps[i]['cost'] as double,
        barcode: maps[i]['barcode'] as String
      );
    });
  }
}