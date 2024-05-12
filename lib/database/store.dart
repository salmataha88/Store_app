class Store {
  int? id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Store({this.id, required this.name,required this.address, required this.latitude, required this.longitude});

  // Factory constructor to convert a Map to a Store object
  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  // Method to convert a Store object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
