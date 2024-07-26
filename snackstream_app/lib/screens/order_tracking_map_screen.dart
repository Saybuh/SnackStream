import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import '../widgets/app_drawer.dart';

class OrderTrackingMapScreen extends StatefulWidget {
  final String orderId;
  final String customerAddress;

  OrderTrackingMapScreen({
    required this.orderId,
    required this.customerAddress,
  });

  @override
  _OrderTrackingMapScreenState createState() => _OrderTrackingMapScreenState();
}

class _OrderTrackingMapScreenState extends State<OrderTrackingMapScreen> {
  LatLng? customerLatLng;
  LatLng? driverLatLng;

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    try {
      customerLatLng = await _getLatLng(widget.customerAddress);
      await _getDriverLocation();
    } catch (e) {
      print('Error initializing tracking: $e');
    }
  }

  Future<LatLng> _getLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations[0].latitude, locations[0].longitude);
      }
    } catch (e) {
      print('Error getting LatLng for address $address: $e');
    }
    throw Exception('Could not find any result for the supplied address or coordinates.');
  }

  Future<void> _getDriverLocation() async {
    try {
      FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            String driverId = data['driverId'];
            DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
                .collection('drivers')
                .doc(driverId)
                .get();
            String driverAddress = driverSnapshot['address'];

            driverLatLng = await _getLatLng(driverAddress);

            setState(() {});
          }
        }
      });
    } catch (e) {
      print('Error getting driver location: $e');
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
          : FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  (customerLatLng!.latitude + driverLatLng!.latitude) / 2,
                  (customerLatLng!.longitude + driverLatLng!.longitude) / 2,
                ),
                initialZoom: 12.0,
                minZoom: 5,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: customerLatLng!,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                    Marker(
                      point: driverLatLng!,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [customerLatLng!, driverLatLng!],
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
