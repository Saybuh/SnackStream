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
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        ChangeNotifierProvider<Cart>(create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: 'Snackstream',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthScreen(),
          '/home': (context) => HomeScreen(),
          '/restaurants': (context) => RestaurantScreen(
              restaurant: Restaurant(
                  id: 'id',
                  name: 'name',
                  address: 'address',
                  imageUrl: 'imageUrl')),
          '/orders': (context) => OrderScreen(),
          '/delivery': (context) => DeliveryScreen(),
          '/cart': (context) => CartScreen(),
          '/checkout': (context) => CheckoutScreen(),
          '/order_confirmation': (context) => OrderConfirmationScreen(),
        },
      ),
    );
  }
}
