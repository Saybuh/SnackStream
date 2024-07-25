import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:snackstream_app/models/restaurant.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'screens/restaurant_screen.dart';
import 'screens/order_screen.dart';
import 'screens/delivery_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/driver_home_screen.dart';
import 'models/cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SnackstreamApp());
}

class SnackstreamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(
          create: (context) => DatabaseService(
            user: context.read<AuthService>().user,
          ),
        ),
        ChangeNotifierProvider<Cart>(create: (_) => Cart()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          if (authService.isLoading) {
            return MaterialApp(
              title: 'Snackstream',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (authService.user == null) {
            return MaterialApp(
              title: 'Snackstream',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: AuthScreen(),
            );
          }

          return MaterialApp(
            title: 'Snackstream',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: authService.userRole == 'driver'
                ? DriverHomeScreen()
                : HomeScreen(),
            routes: {
              '/home': (context) => authService.userRole == 'customer'
                  ? HomeScreen()
                  : AuthScreen(),
              '/restaurants': (context) => authService.userRole == 'customer'
                  ? RestaurantScreen(
                      restaurant: Restaurant(
                        id: 'id',
                        name: 'name',
                        address: 'address',
                        imageUrl: 'imageUrl',
                      ),
                    )
                  : AuthScreen(),
              '/orders': (context) => authService.userRole == 'customer'
                  ? OrderScreen()
                  : AuthScreen(),
              '/delivery': (context) => authService.userRole == 'customer'
                  ? DeliveryScreen()
                  : AuthScreen(),
              '/cart': (context) => authService.userRole == 'customer'
                  ? CartScreen()
                  : AuthScreen(),
              '/checkout': (context) => authService.userRole == 'customer'
                  ? CheckoutScreen()
                  : AuthScreen(),
              '/order_confirmation': (context) =>
                  authService.userRole == 'customer'
                      ? OrderConfirmationScreen()
                      : AuthScreen(),
              '/reviews': (context) => authService.userRole == 'customer'
                  ? ReviewsScreen()
                  : AuthScreen(),
              '/driver_home': (context) => authService.userRole == 'driver'
                  ? DriverHomeScreen()
                  : AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
