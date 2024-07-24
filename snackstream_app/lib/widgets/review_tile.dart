import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  final String reviewerName;
  final String reviewText;
  final int rating;

  ReviewTile({
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
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
        ],
      ),
    );
  }
}
