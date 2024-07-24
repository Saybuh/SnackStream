import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fooddeliveryapp/models/review.dart' as model;

Future<void> addReview(String orderId, model.Review review) {
  return firestore.FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .collection('reviews')
      .add({
    'userId': review.userId,
    'comment': review.comment,
    'rating': review.rating,
    'timestamp': review.timestamp,
  });
}
