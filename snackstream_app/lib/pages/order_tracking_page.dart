import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fooddeliveryapp/services/order_service.dart';
import 'package:fooddeliveryapp/models/order.dart' as model;
import 'package:fooddeliveryapp/services/order_service.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;

  OrderTrackingPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Tracking')),
      body: StreamBuilder<model.Order>(
        stream: getOrderUpdates(orderId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          model.Order order = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Order ID: ${order.id}'),
              Text('Status: ${order.status}'),
              Text('Driver ID: ${order.driverId}'),
              Text('Timestamp: ${order.timestamp.toDate()}'),
            ],
          );
        },
      ),
    );
  }
}
