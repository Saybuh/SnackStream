import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String customerAddress;
  final String restaurantAddress;

  OrderTrackingScreen(
      {required this.customerAddress, required this.restaurantAddress});

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late GoogleMapController mapController;
  late LatLng customerLatLng;
  late LatLng restaurantLatLng;

  @override
  void initState() {
    super.initState();
    _getLatLng(widget.customerAddress).then((latLng) {
      setState(() {
        customerLatLng = latLng;
      });
    });
    _getLatLng(widget.restaurantAddress).then((latLng) {
      setState(() {
        restaurantLatLng = latLng;
      });
    });
  }

  Future<LatLng> _getLatLng(String address) async {
    // Use Geolocator or another package to convert address to LatLng
    // This is a placeholder implementation
    return LatLng(0.0, 0.0); // Replace with actual lat and lng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: customerLatLng == null || restaurantLatLng == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: customerLatLng,
                zoom: 12,
              ),
              markers: {
                Marker(
                    markerId: MarkerId('customer'), position: customerLatLng),
                Marker(
                    markerId: MarkerId('restaurant'),
                    position: restaurantLatLng),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: [customerLatLng, restaurantLatLng],
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
    );
  }
}
