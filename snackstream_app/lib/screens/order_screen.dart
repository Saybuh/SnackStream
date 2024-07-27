import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
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
          if (orders.isEmpty) {
            return Center(child: Text('No orders found.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ExpansionTile(
                title: Text('Order ID: ${order['id']}'),
                subtitle: Text('Total: \$${order['total']}'),
                children: [
                  ...order['items'].map<Widget>((item) {
                    return ListTile(
                      title: Text(item['name']),
                      subtitle: Text('Price: \$${item['price']}'),
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
