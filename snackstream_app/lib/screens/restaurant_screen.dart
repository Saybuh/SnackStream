import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/restaurant.dart';

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: databaseService.getRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final restaurants = snapshot.data ?? [];
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurantData = restaurants[index];
              final restaurant = Restaurant.fromFirestore(
                  restaurantData, restaurantData['id']);
              return ListTile(
                title: Text(restaurant.name),
                subtitle: Text(restaurant.address),
                leading: Image.network(restaurant.imageUrl),
              );
            },
          );
        },
      ),
    );
  }
}
