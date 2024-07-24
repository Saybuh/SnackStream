import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/pages/driver_info_page.dart';
import 'package:fooddeliveryapp/pages/order_tracking_page.dart';
import 'package:fooddeliveryapp/pages/reviews_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/restaurant.dart';
import 'services/auth/auth_gate.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),

        // restaurant provider
        ChangeNotifierProvider(create: (context) => Restaurant()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/order-tracking': (context) =>
            OrderTrackingPage(orderId: 'orderId'), // Adjust orderId dynamically
        '/reviews': (context) =>
            ReviewsPage(orderId: 'orderId'), // Adjust orderId dynamically
        '/driver-info': (context) =>
            DriverInfoPage(driverId: 'driverId'), // Adjust driverId dynamically
      },
    );
  }
}
