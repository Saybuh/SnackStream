import 'package:flutter/material.dart';

class MyDrawerListTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const MyDrawerListTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // text style
    var drawerTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    // list tile
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 0),
      child: ListTile(
        title: Text(
          text,
          style: drawerTextStyle,
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onTap: onTap,
      ),
    );
  }
}
