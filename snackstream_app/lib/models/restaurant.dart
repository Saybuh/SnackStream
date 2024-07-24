class Restaurant {
  final String id;
  final String name;
  final String address;
  final String imageUrl;

  Restaurant(
      {required this.id,
      required this.name,
      required this.address,
      required this.imageUrl});

  factory Restaurant.fromFirestore(Map<String, dynamic> data, String id) {
    return Restaurant(
      id: id,
      name: data['name'],
      address: data['address'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'imageUrl': imageUrl,
    };
  }
}
