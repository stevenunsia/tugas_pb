import 'package:flutter/material.dart';

class AddEditReviewScreen extends StatefulWidget {
  const AddEditReviewScreen({super.key});

  @override
  AddEditReviewScreenState createState() => AddEditReviewScreenState();
}

class AddEditReviewScreenState extends State<AddEditReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add/Edit Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(labelText: 'Review'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveReview,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveReview() async {
    final review = _reviewController.text;
    if (review.isEmpty) return;

    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));

    if (!mounted) return;

    // Use the context safely
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review saved!')),
    );

    Navigator.of(context).pop();
  }
}