import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fooddeliveryapp/services/driver_service.dart';
import 'package:fooddeliveryapp/models/driver.dart' as model;

class DriverInfoPage extends StatelessWidget {
  final String driverId;

  DriverInfoPage({required this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driver Information')),
      body: StreamBuilder<model.Driver>(
        stream: getDriver(driverId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          model.Driver driver = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Driver ID: ${driver.id}'),
              Text('Name: ${driver.name}'),
              Text('Phone Number: ${driver.phoneNumber}'),
            ],
          );
        },
      ),
    );
  }
}
