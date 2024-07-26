import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../widgets/app_drawer.dart';

class OrderTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: databaseService.getAcceptedOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(child: Text('No orders to track.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order ID: ${order['id']}'),
                subtitle: Text('Delivery Address: ${order['customerAddress']}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/order_tracking_map',
                    arguments: {
                      'orderId': order['id'],
                      'customerAddress': order['customerAddress'],
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
