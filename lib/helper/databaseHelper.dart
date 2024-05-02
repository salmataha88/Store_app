import '../database/store.dart';
import '../database/user.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath() , 'Stores.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        password TEXT,
        latitude REAL,
        longitude REAL,
        favoriteStores TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE stores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        address TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
    print("==========Create db=========");
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertStore(Store store) async {
    final db = await database;
    await db.insert(
      'stores',
      store.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Store>> getStores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('stores');
    return List.generate(maps.length, (i) {
      return Store.fromMap(maps[i]);
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    print(users.first);
    return users.isNotEmpty ? users.first : null;
  }

  Future<bool> isEmailExists(String email) async {
    final db = await instance.database;
    var res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty;
  }

  Future<void> updateFavoriteStores(String email, List<int> favoriteStores) async {
    try {
      Database db = await instance.database;
      int rowsAffected = await db.update(
        'users',
        {'favoriteStores': favoriteStores.join(',')},
        where: 'email = ?',
        whereArgs: [email],
      );
      print('Updated $rowsAffected rows');
    } catch (e) {
      print('Error updating user favorite stores: $e');
    }
  }

}

