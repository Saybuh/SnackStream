import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // is dark mode
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Center(
      child: Lottie.asset(
        isDarkMode
            ? 'lib/animation/delivery_animation_white.json'
            : 'lib/animation/delivery_animation_black.json',
        height: 200,
      ),
    );
  }
}
