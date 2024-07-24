import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String userId;
  String comment;
  double rating;
  Timestamp timestamp;

  Review(
      {required this.userId,
      required this.comment,
      required this.rating,
      required this.timestamp});

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Review(
      userId: data['userId'] ?? '',
      comment: data['comment'] ?? '',
      rating: data['rating']?.toDouble() ?? 0.0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
