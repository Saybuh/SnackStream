import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderTile extends StatelessWidget {
  final Order order;

  OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Order ID: ${order.id}'),
      subtitle: Text('Status: ${order.status}'),
    );
  }
}
