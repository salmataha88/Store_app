class User {
  int? id;
  final String email;
  final String password;
  final double latitude;
  final double longitude;
  List<int> favoriteStores; // Change the type to List<int>

  User({
    this.id,
    required this.email,
    required this.password,
    required this.latitude,
    required this.longitude,
    List<int>? favoriteStores, // Update the parameter type
  }) : favoriteStores = favoriteStores ?? [];

  // Method to add a store to favorite stores
  void addToFavorites(int storeId) { // Update the parameter type
    favoriteStores.add(storeId); // No need to access store.id directly
  }

  // Method to remove a store from favorite stores
  void removeFromFavorites(int storeId) { // Update the parameter type
    favoriteStores.remove(storeId); // Use remove method with the integer id
  }

  // Method to convert a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'latitude': latitude,
      'longitude': longitude,
      'favoriteStores': favoriteStores,
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
      favoriteStores: List<int>.from(map['favoriteStores']), // Update the type conversion
    );
  }
}
