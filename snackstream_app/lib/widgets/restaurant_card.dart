import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(restaurant.imageUrl),
          Text(restaurant.name),
          Text(restaurant.address),
        ],
      ),
    );
  }
}
