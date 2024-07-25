import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  final String reviewerName;
  final String reviewText;
  final int rating;
  final String orderId;

  ReviewTile({
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reviewerName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reviewText),
          Row(
            children: List.generate(
                rating, (index) => Icon(Icons.star, color: Colors.amber)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/order', arguments: orderId);
            },
            child: Text(
              'Order ID: $orderId',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
