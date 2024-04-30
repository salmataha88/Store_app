import 'store.dart';

class User {
  int? id;
  final String email;
  final String password;
  final double latitude;
  final double longitude;
  List<Store> favoriteStores;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.latitude,
    required this.longitude,
    List<Store>? favoriteStores,
  }) : favoriteStores = favoriteStores ?? [];

  // Method to add a store to favorite stores
  void addToFavorites(Store store) {
    favoriteStores.add(store);
  }

  // Method to remove a store from favorite stores
  void removeFromFavorites(Store store) {
    favoriteStores.removeWhere((s) => s.id == store.id);
  }

  // Method to convert a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'latitude': latitude,
      'longitude': longitude,
      'favoriteStores': favoriteStores.map((store) => store.toMap()).toList(),
    };
  }

  // Factory constructor to convert a Map to a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      favoriteStores: List<Store>.from(map['favoriteStores'].map((store) => Store.fromMap(store))),
    );
  }
}
