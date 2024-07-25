import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/order_screen.dart';
import '../screens/customer_reviews_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/driver_home_screen.dart';
import '../screens/order_tracking_screen.dart'; // Import the OrderTrackingScreen

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('SnackStream'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          if (userRole == 'customer') ...[
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Orders'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrderScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Reviews'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerReviewsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Order Tracking'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderTrackingScreen(
                      customerAddress: 'Your customer address',
                      orderId: 'Your order ID', // Pass the correct order ID
                    ),
                  ),
                );
              },
            ),
          ] else if (userRole == 'driver') ...[
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DriverHomeScreen()),
                );
              },
            ),
          ],
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
