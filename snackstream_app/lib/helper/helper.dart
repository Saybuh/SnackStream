import 'package:flutter/material.dart';

void openBox(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Center(child: Text(title)),
    ),
  );
}
