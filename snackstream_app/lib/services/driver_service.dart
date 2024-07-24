import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fooddeliveryapp/models/driver.dart' as model;

Stream<model.Driver> getDriver(String driverId) {
  return firestore.FirebaseFirestore.instance
      .collection('drivers')
      .doc(driverId)
      .snapshots()
      .map((snapshot) => model.Driver.fromFirestore(snapshot));
}
