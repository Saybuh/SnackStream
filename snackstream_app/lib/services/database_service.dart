import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a restaurant
  Future<void> addRestaurant(Map<String, dynamic> data) async {
    await _db.collection('restaurants').add(data);
  }

  // Fetch restaurants
  Stream<List<Map<String, dynamic>>> getRestaurants() {
    return _db
        .collection('restaurants')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
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
}
