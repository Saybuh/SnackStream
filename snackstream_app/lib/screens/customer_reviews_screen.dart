import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_drawer.dart';
import '../widgets/review_tile.dart';
import '../services/auth_service.dart';
import 'add_review_screen.dart';

class CustomerReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Reviews'),
      ),
      drawer: AppDrawer(),
      body: user == null
          ? Center(child: Text('Please log in to view your reviews.'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reviews')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error loading reviews.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No reviews found.'));
                }

                final reviews = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ReviewTile(
                      reviewerName: user.displayName ?? 'Anonymous',
                      reviewText: review['reviewText'],
                      rating: review['rating'],
                      orderId: review['orderId'],
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Fetch the user's orders
          final ordersSnapshot = await FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: user!.uid)
              .get();

          if (ordersSnapshot.docs.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You have no orders to review.')),
            );
            return;
          }

          // Show a dialog to select an order
          showDialog(
            context: context,
            builder: (context) {
              String? selectedOrderId;
              return AlertDialog(
                title: Text('Select Order to Review'),
                content: Container(
                  width: double.minPositive,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ordersSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      final order = ordersSnapshot.docs[index];
                      return ListTile(
                        title: Text('Order ${order['id']}'),
                        onTap: () {
                          selectedOrderId = order.id;
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddReviewScreen(id: selectedOrderId!),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
