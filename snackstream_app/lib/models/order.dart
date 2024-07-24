import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String status;
  String driverId;
  Timestamp timestamp;

  Order(
      {required this.id,
      required this.status,
      required this.driverId,
      required this.timestamp});

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Order(
      id: doc.id,
      status: data['status'] ?? '',
      driverId: data['driverId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
