import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fooddeliveryapp/models/review.dart' as model;
import 'package:fooddeliveryapp/services/review_service.dart';

Stream<List<model.Review>> getReviews(String orderId) {
  return firestore.FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .collection('reviews')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => model.Review.fromFirestore(doc)).toList());
}

class ReviewsPage extends StatelessWidget {
  final String orderId;

  ReviewsPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews')),
      body: StreamBuilder<List<model.Review>>(
        stream: getReviews(orderId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<model.Review> reviews = snapshot.data!;
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              model.Review review = reviews[index];
              return ListTile(
                title: Text(review.comment),
                subtitle: Text('Rating: ${review.rating}'),
                trailing: Text(review.timestamp.toDate().toString()),
              );
            },
          );
        },
      ),
    );
  }
}
