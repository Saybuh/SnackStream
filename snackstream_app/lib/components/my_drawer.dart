import 'package:flutter/material.dart';
import '../pages/settings_page.dart';
import '../pages/order_tracking_page.dart';
import '../pages/reviews_page.dart';
import '../pages/driver_info_page.dart';
import '../services/auth/auth_service.dart';
import 'my_drawer_list_tile.dart';
import 'my_logo.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // logout
  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // app logo
          const Padding(
            padding: EdgeInsets.only(top: 100),
            child: Center(
              child: MyLogo(),
            ),
          ),

          // divider line
          Padding(
            padding: const EdgeInsets.all(25),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // home list tile
          MyDrawerListTile(
            text: "H O M E",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          // settings list tile
          MyDrawerListTile(
            text: "S E T T I N G S",
            icon: Icons.settings,
            onTap: () {
              // pop drawer
              Navigator.pop(context);

              // go to settings page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),

          // order tracking list tile
          MyDrawerListTile(
            text: "O R D E R  T R A C K I N G",
            icon: Icons.track_changes,
            onTap: () {
              // pop drawer
              Navigator.pop(context);

              // go to order tracking page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderTrackingPage(
                      orderId: 'orderId'), // Replace with actual orderId
                ),
              );
            },
          ),

          // reviews list tile
          MyDrawerListTile(
            text: "R E V I E W S",
            icon: Icons.reviews,
            onTap: () {
              // pop drawer
              Navigator.pop(context);

              // go to reviews page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewsPage(
                      orderId: 'orderId'), // Replace with actual orderId
                ),
              );
            },
          ),

          // driver info list tile
          MyDrawerListTile(
            text: "D R I V E R  I N F O",
            icon: Icons.info,
            onTap: () {
              // pop drawer
              Navigator.pop(context);

              // go to driver info page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverInfoPage(
                      driverId: 'driverId'), // Replace with actual driverId
                ),
              );
            },
          ),

          const Spacer(),

          // logout list tile
          MyDrawerListTile(
            text: "L O G O U T",
            icon: Icons.logout,
            onTap: () {
              logout();
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
