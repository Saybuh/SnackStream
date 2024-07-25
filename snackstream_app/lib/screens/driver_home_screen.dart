import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../widgets/app_drawer.dart';

class DriverHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Order Queue'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: databaseService.getDriverOrders(),
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
              final order = orders[index];
              return ListTile(
                title: Text('Order ID: ${order['id']}'),
                subtitle: Text('Total: \$${order['total']}'),
                trailing: DropdownButton<String>(
                  value: order['status'],
                  items: ['pending', 'accepted', 'delivered']
                      .map((status) => DropdownMenuItem(
                            child: Text(status),
                            value: status,
                          ))
                      .toList(),
                  onChanged: (newStatus) {
                    databaseService.updateOrderStatus(order['id'], newStatus!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
