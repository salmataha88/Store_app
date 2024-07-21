  import '../database/store.dart';
  import '../database/user.dart';
  import 'storeProvider.dart';

  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';
  import 'dart:math' show sin, cos, sqrt, atan2, pow, pi;


  class DatabaseHelper {
    static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
    static Database? _database;
    late StoreProvider storeProvider; // Define StoreProvider

    DatabaseHelper._privateConstructor();

    // Factory constructor to ensure singleton instance
    factory DatabaseHelper.withProvider(StoreProvider storeProvider) =>
      instance..storeProvider = storeProvider;

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

    void setStoreProvider(StoreProvider provider) {
      storeProvider = provider;
      print('----------------prov----------------');
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

 Future<Map<String, dynamic>?> getUserByEmail(String email, StoreProvider storeProvider) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    print(users.first);
    if (users.isNotEmpty) {
      // Create User object from database data
      User user = User.fromMap(users.first);

      print("User in StoreProvider before set: ${storeProvider.currentUser}");
      
      // Set the current user in StoreProvider
      storeProvider.setCurrentUser(user);

      print("User set in StoreProvider: ${storeProvider.currentUser}");
      
      return users.first;
    } else {
      return null;
    }
  }

    Future<bool> isEmailExists(String email) async {
      final db = await instance.database;
      var res = await db.query('users', where: 'email = ?', whereArgs: [email]);
      return res.isNotEmpty;
    }

    Future<void> updateUser(User user) async {
      try {
        final Database db = await instance.database;
        await db.update(
          'users',
          user.toMap(),
          where: 'email = ?',
          whereArgs: [user.email],
        );
        print('User updated successfully');
      } catch (e) {
        print('Error updating user: $e');
        throw e; 
      }
    }

    // Method to get stores by ID and sort them based on distance
    Future<List<Store>> sortByDistance(List<Store> stores, double userLat, double userLon) async {
      try {
        // Sort stores based on distance
        stores.sort((a, b) { 
          final distanceToA = _calculateDistance(userLat, userLon, a.latitude, a.longitude);
          final distanceToB = _calculateDistance(userLat, userLon, b.latitude, b.longitude);
          print('============Distance A : $distanceToA =============');
          print(a.name);
          print('============Distance A $b: $distanceToB=============');
          print(b.name);
          return distanceToA.compareTo(distanceToB);
        });

        return stores;
      } catch (e) {
        print('Error getting and sorting stores: $e');
        throw e;
      }
    }

    double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
      const double earthRadius = 6371.0; // Earth's radius in kilometers

      // Convert latitude and longitude from degrees to radians
      final double lat1Rad = lat1 * pi / 180.0;
      final double lon1Rad = lon1 * pi / 180.0;
      final double lat2Rad = lat2 * pi / 180.0;
      final double lon2Rad = lon2 * pi / 180.0;

      // Calculate the differences in latitude and longitude
      final double dLat = lat2Rad - lat1Rad;
      final double dLon = lon2Rad - lon1Rad;

      // Haversine formula to calculate distance
      final double a = pow(sin(dLat / 2), 2) +
          cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
      final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      final double distance = earthRadius * c;

      return distance;
    }

    

  }

