class User {
  int? id;
  final String email;
  final String password;
  final double latitude;
  final double longitude;
  List<int> favoriteStores;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.latitude,
    required this.longitude,
    List<int>? favoriteStores,
  }) : favoriteStores = favoriteStores ?? [];


  void addToFavorites(int storeId) { 
    favoriteStores.add(storeId); 
  }

  void removeFromFavorites(int storeId) { 
    favoriteStores.remove(storeId); 
  }

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

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      favoriteStores: List<int>.from(map['favoriteStores']),
    );
  }
}
