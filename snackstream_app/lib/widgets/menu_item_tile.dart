import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onAddToCart;

  MenuItemTile({required this.menuItem, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(menuItem.imageUrl),
      title: Text(menuItem.name),
      subtitle: Text(menuItem.description),
      trailing: Text('\$${menuItem.price.toStringAsFixed(2)}'),
      onTap: onAddToCart,
    );
  }
}
