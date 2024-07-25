import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? user;

  DatabaseService({this.user});

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
    final orderRef = await _db.collection('orders').add({
      ...data,
      'userId': user?.uid,
      'status': 'pending',
      'total': data['items'].fold(0, (sum, item) => sum + item['price']),
    });

    // Update the order with the document ID
    await orderRef.update({
      'id': orderRef.id,
    });
  }

  // Fetch user orders
  Stream<List<Map<String, dynamic>>> getOrders() {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: user?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id,
                })
            .toList());
  }

  // Fetch driver orders
  Stream<List<Map<String, dynamic>>> getDriverOrders() {
    return _db
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id,
                })
            .toList());
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status,
    });
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
