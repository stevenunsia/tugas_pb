import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class MovieReviewsScreen extends StatefulWidget {
  final String username;

  const MovieReviewsScreen({super.key, required this.username});

  @override
  MovieReviewsScreenState createState() => MovieReviewsScreenState();
}

class MovieReviewsScreenState extends State<MovieReviewsScreen> {
  final Logger _logger = Logger('MovieReviewsScreen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Reviews')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                try {
                  // Simulate a network call
                  await Future.delayed(Duration(seconds: 2));
                  if (!mounted) return;
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddEditReviewScreen(
                          username: widget.username,
                          review: 'exampleReview',
                        ),
                      ),
                    );
                  }
                } catch (error) {
                  _logger.severe('Error navigating to AddEditReviewScreen: $error');
                }
              },
              child: Text('Add/Edit Review'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEditReviewScreen extends StatelessWidget {
  final String username;
  final String review;

  const AddEditReviewScreen({
    super.key,
    required this.username,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add/Edit Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Username: $username'),
            Text('Review: $review'),
          ],
        ),
      ),
    );
  }
}