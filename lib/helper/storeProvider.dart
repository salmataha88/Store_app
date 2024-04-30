import 'package:flutter/material.dart';
import '../database/store.dart';
import 'databaseHelper.dart';

class StoreProvider extends ChangeNotifier {
  List<Store> _allStores = [];

  // Method to fetch all stores from the database
  Future<List<Store>> getAllStores() async {
    try {
      _allStores = await DatabaseHelper.instance.getStores();
      notifyListeners();
      return _allStores;
    } catch (e) {
      print('Failed to get all stores: $e');
      throw e;
    }
  }

  // Getter to access the list of all stores
  List<Store> get allStores => _allStores;
}
