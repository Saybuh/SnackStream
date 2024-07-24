import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fooddeliveryapp/models/order.dart' as model;

Stream<model.Order> getOrderUpdates(String orderId) {
  return firestore.FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .snapshots()
      .map((snapshot) => model.Order.fromFirestore(snapshot));
}
