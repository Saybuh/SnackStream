import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../models/restaurant.dart';

class MyCartIconButton extends StatelessWidget {
  final void Function()? onPressed;

  const MyCartIconButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // cart length
    int cartLength = Provider.of<Restaurant>(context).getTotalItemCount();

    return IconButton(
      onPressed: onPressed,
      icon: badges.Badge(
        position: badges.BadgePosition.topEnd(top: -12, end: -8),
        showBadge: cartLength == 0 ? false : true,
        badgeContent: Text(
          cartLength > 9 ? '' : cartLength.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        badgeAnimation: const badges.BadgeAnimation.rotation(
          animationDuration: Duration(seconds: 1),
          colorChangeAnimationDuration: Duration(seconds: 1),
          loopAnimation: false,
          curve: Curves.fastOutSlowIn,
          colorChangeAnimationCurve: Curves.easeInCubic,
        ),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
