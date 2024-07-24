import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a restaurant with menu items
  Future<void> addRestaurantWithMenuItems(Map<String, dynamic> data) async {
    final restaurantRef = await _db.collection('restaurants').add({
      'name': data['name'],
      'address': data['address'],
      'imageUrl': data['imageUrl'],
    });

    for (var menuItem in data['menuItems']) {
      await restaurantRef.collection('menu_items').add(menuItem);
    }
  }

  // Fetch restaurants
  Stream<List<Map<String, dynamic>>> getRestaurants() {
    return _db
        .collection('restaurants')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id,
                })
            .toList());
  }

  // Add an order
  Future<void> addOrder(Map<String, dynamic> data) async {
    await _db.collection('orders').add(data);
  }

  // Fetch orders
  Stream<List<Map<String, dynamic>>> getOrders() {
    return _db
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Fetch menu items for a restaurant
  Stream<List<Map<String, dynamic>>> getMenuItems(String restaurantId) {
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu_items')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id,
                })
            .toList());
  }
}
