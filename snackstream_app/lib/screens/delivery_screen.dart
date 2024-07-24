import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/order.dart';

class DeliveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Orders'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: databaseService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index];
              final order = Order.fromFirestore(orderData, orderData['id']);
              return ListTile(
                title: Text(order.id),
                subtitle: Text(order.status),
              );
            },
          );
        },
      ),
    );
  }
}
