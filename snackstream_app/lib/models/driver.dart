import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  String id;
  String name;
  String phoneNumber;

  Driver({required this.id, required this.name, required this.phoneNumber});

  factory Driver.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Driver(
      id: doc.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }
}
