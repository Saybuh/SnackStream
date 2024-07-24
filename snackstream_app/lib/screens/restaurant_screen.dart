import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/cart.dart';
import '../widgets/menu_item_tile.dart';
import 'cart_screen.dart';

class RestaurantScreen extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantScreen({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: databaseService.getMenuItems(restaurant.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final menuItems = snapshot.data ?? [];
          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final menuItemData = menuItems[index];
              final menuItem =
                  MenuItem.fromFirestore(menuItemData, menuItemData['id']);
              return MenuItemTile(
                menuItem: menuItem,
                onAddToCart: () {
                  cart.addItem(menuItem);
                },
              );
            },
          );
        },
      ),
    );
  }
}
