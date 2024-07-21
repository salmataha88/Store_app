import 'package:flutter/material.dart';
import '../database/store.dart';
import '../database/user.dart'; 
import 'databaseHelper.dart';

class StoreProvider extends ChangeNotifier {
  List<Store> _allStores = [];
  User? _currentUser ; 


  void setCurrentUser(User user) {
    _currentUser = user;
    print("---------------set------------------ $_currentUser");
  }
  User? get currentUser => _currentUser;

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

  List<Store> get allStores => _allStores;

  Future<void> addRemoveFavoriteStores(int storeId) async {
    print("-------------add fav user------------------ $currentUser");
    print('Inside addToFavorites');
    if (currentUser != null) {
      print('User is not null');
      if (!currentUser!.favoriteStores.contains(storeId)) {
        currentUser!.addToFavorites(storeId);
        try {
          await DatabaseHelper.instance.updateUser(currentUser!);
          notifyListeners();
        } catch (e) {
          print('Error updating user: $e');
          // Handle the error as needed
        }
      } else {
        print('Store already in favorites');
        currentUser!.removeFromFavorites(storeId);
        try {
          await DatabaseHelper.instance.updateUser(currentUser!);
          notifyListeners();
        } catch (e) {
          print('Error updating user: $e');
        }
      }
    } else {
      print('User is null'); // Check if user is null
    }
    print('===========================');
    return;
  }


  List<Store> get favoriteStores {
    if (currentUser != null) {
      print("============== fav stores==========");
      return _allStores.where((store) => currentUser!.favoriteStores.contains(store.id)).toList();
    } else {
      print(("No Fav Stores Yet"));
      return [];
    }
  }

  Future<List<Store>> getFavStoresByIds(List<int> storeIds) async {
  List<Store> favoriteStores = [];
  try {
    List<Store> allStores = await getAllStores();
    for (int id in storeIds) {
      Store? store = allStores.firstWhere((store) => store.id == id);
      print("==============stores==========");
      if (store != null) {
        favoriteStores.add(store);
      }
    }
    return favoriteStores;
  } catch (e) {
    print('Failed to get favorite stores by IDs: $e');
    throw e;
  }
}

  Future<List<Store>> getFavStoresByDistance() async {
    try {
      // Get favorite stores by IDs
      List<int> favoriteStoreIds = currentUser?.favoriteStores ?? [];
      List<Store> favoriteStores = await getFavStoresByIds(favoriteStoreIds);
      
      // Sort favorite stores by distance
      favoriteStores = await DatabaseHelper.instance.sortByDistance(favoriteStores, currentUser!.latitude, currentUser!.longitude);
      
      return favoriteStores;
    } catch (e) {
      print('Failed to get favorite stores sorted by distance: $e');
      throw e;
    }
  }


}
