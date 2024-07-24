import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'screens/restaurant_screen.dart';
import 'screens/order_screen.dart';
import 'screens/delivery_screen.dart';
import 'screens/home_screen.dart';

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
          '/restaurants': (context) => RestaurantScreen(),
          '/orders': (context) => OrderScreen(),
          '/delivery': (context) => DeliveryScreen(),
        },
      ),
    );
  }
}
