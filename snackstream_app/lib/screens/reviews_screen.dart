import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Reviews Screen'),
      ),
    );
  }
}
