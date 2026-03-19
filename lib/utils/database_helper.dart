// lib/utils/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cart_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'cart.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  Future<void> _onUpgrade(Database db, int oldV, int newV) async {
    // Xóa bảng cũ và tạo lại
    await db.execute('DROP TABLE IF EXISTS Cart');
    await _onCreate(db, newV);
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Cart (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        productId     TEXT    NOT NULL,
        name          TEXT    NOT NULL,
        imageUrl      TEXT    NOT NULL,
        price         REAL    NOT NULL,
        originalPrice REAL    NOT NULL,
        quantity      INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Seed data mẫu
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final items = [
      {
        'productId': 'p1',
        'name': 'iPhone 15',
        'imageUrl': 'https://m.media-amazon.com/images/I/71d7rfSl0wL._SL1500_.jpg',
        'price': 999.0,
        'originalPrice': 1099.0,
        'quantity': 1,
      },
      {
        'productId': 'p2',
        'name': 'Samsung S24',
        'imageUrl': 'https://azmobile.net/pic/product/ca543cc0-4274-49b3-aef7-d8c1bbe3f9ea.jpg',
        'price': 699.0,
        'originalPrice': 799.0,
        'quantity': 2,
      },
      {
        'productId': 'p3',
        'name': 'MacBook Air',
        'imageUrl': 'https://www.maccenter.vn/App_images/MacBookAir-15-M3-Midnight-A.jpg',
        'price': 1299.0,
        'originalPrice': 1499.0,
        'quantity': 1,
      },
    ];
    for (final item in items) {
      await db.insert('Cart', item);
    }
  }

  // ── CRUD ─────────────────────────────────────────────────────────

  Future<List<CartItem>> getAllItems() async {
    final db = await database;
    final maps = await db.query('Cart', orderBy: 'id ASC');
    return maps.map((m) => CartItem.fromMap(m)).toList();
  }

  Future<int> insertItem(CartItem item) async {
    final db = await database;
    // Nếu sản phẩm đã có trong giỏ → tăng quantity
    final existing = await db.query(
      'Cart',
      where: 'productId = ?',
      whereArgs: [item.productId],
    );
    if (existing.isNotEmpty) {
      final current = CartItem.fromMap(existing.first);
      return await db.update(
        'Cart',
        {'quantity': current.quantity + item.quantity},
        where: 'productId = ?',
        whereArgs: [item.productId],
      );
    }
    return await db.insert('Cart', item.toMap());
  }

  Future<int> updateQuantity(int id, int quantity) async {
    final db = await database;
    if (quantity <= 0) {
      return await db.delete('Cart', where: 'id = ?', whereArgs: [id]);
    }
    return await db.update(
      'Cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('Cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('Cart');
  }
}