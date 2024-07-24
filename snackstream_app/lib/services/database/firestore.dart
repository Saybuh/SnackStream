import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of orders
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  // save order to db
  Future<void> saveOrderToDatabase(String receipt) async {
    // Add to collection of orders
    await orders.add({
      'date': DateTime.now(), // Store the current date and time
      'order': receipt, // Store the generated receipt
      // You can add more fields as necessary
    });
  }
}
