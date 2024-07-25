import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class AddReviewScreen extends StatefulWidget {
  final String id;

  AddReviewScreen({required this.id});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: user == null
          ? Center(child: Text('Please log in to add a review.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _reviewController,
                      decoration: InputDecoration(labelText: 'Review'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a review';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && _rating > 0) {
                          await FirebaseFirestore.instance
                              .collection('reviews')
                              .add({
                            'orderId': widget.id,
                            'userId': user.uid,
                            'reviewerName': user.displayName ?? 'Anonymous',
                            'reviewText': _reviewController.text,
                            'rating': _rating,
                            'createdAt': Timestamp.now(),
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
