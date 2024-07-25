import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import '../widgets/app_drawer.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String customerAddress;
  final String orderId;

  OrderTrackingScreen({
    required this.customerAddress,
    required this.orderId,
  });

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late GoogleMapController mapController;
  LatLng? customerLatLng;
  LatLng? driverLatLng;
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    try {
      customerLatLng = await _getLatLng(widget.customerAddress);
      print('Customer LatLng: $customerLatLng');
      await _getDriverLocation();
      _drawRoute();
    } catch (e) {
      print('Error initializing tracking: $e');
    }
  }

  Future<LatLng> _getLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        throw Exception('Could not find any result for the supplied address.');
      }
      print(
          'LatLng for address $address: ${locations[0].latitude}, ${locations[0].longitude}');
      return LatLng(locations[0].latitude, locations[0].longitude);
    } catch (e) {
      print('Error getting LatLng for address $address: $e');
      rethrow;
    }
  }

  Future<void> _getDriverLocation() async {
    try {
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .get();
      if (orderSnapshot.exists) {
        String driverId = orderSnapshot['driverId'];
        print('Driver ID: $driverId');
        DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
            .collection('drivers')
            .doc(driverId)
            .get();
        if (driverSnapshot.exists) {
          String driverAddress = driverSnapshot['address'];
          print('Driver Address: $driverAddress');
          driverLatLng = await _getLatLng(driverAddress);
          print('Driver LatLng: $driverLatLng');
        } else {
          throw Exception('Driver document does not exist.');
        }
      } else {
        throw Exception('Order document does not exist.');
      }
    } catch (e) {
      print('Error getting driver location: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      drawer: AppDrawer(),
      body: customerLatLng == null || driverLatLng == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                _drawRoute();
              },
              initialCameraPosition: CameraPosition(
                target: customerLatLng!,
                zoom: 12,
              ),
              markers: {
                Marker(
                    markerId: MarkerId('customer'), position: customerLatLng!),
                Marker(markerId: MarkerId('driver'), position: driverLatLng!),
              },
              polylines: _polylines,
            ),
    );
  }

  void _drawRoute() {
    if (customerLatLng != null && driverLatLng != null) {
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: [customerLatLng!, driverLatLng!],
            color: Colors.blue,
            width: 5,
          ),
        );
        print('Route drawn from $customerLatLng to $driverLatLng');
      });
    }
  }
}
