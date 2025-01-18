import 'package:flutter/material.dart';
import '../api_service.dart';
import 'add_edit_review_screen.dart';

class MovieReviewsScreen extends StatefulWidget {
  final String username;

  const MovieReviewsScreen({Key? key, required this.username})
      : super(key: key);

  @override
  _MovieReviewsScreenState createState() => _MovieReviewsScreenState();
}

class _MovieReviewsScreenState extends State<MovieReviewsScreen> {
  final _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _loadReviews();
  }

  Future<List<Map<String, dynamic>>> _loadReviews() async {
    try {
      final reviews = await _apiService.getReviews(widget.username);
      return reviews.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading reviews: $e');
      return [];
    }
  }

  Future<void> _deleteReview(String id) async {
    try {
      final success = await _apiService.deleteReview(id);
      if (success) {
        setState(() {
          _reviewsFuture = _loadReviews(); // Refresh data secara global
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus review')),
        );
      }
    } catch (e) {
      print('Error deleting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat menghapus review')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Film Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditReviewScreen(username: widget.username),
                ),
              );
              if (result == true) {
                setState(() {
                  _reviewsFuture = _loadReviews();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan saat memuat data: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Belum ada review. Tambahkan sekarang!'),
            );
          } else if (snapshot.hasData) {
            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                final id = review['_id'] ?? ''; // Validasi key `_id`
                if (id.isEmpty) {
                  return const SizedBox.shrink(); // Abaikan jika `_id` kosong
                }
                return ReviewListItem(
                  review: review,
                  onEdit: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditReviewScreen(
                          username: widget.username,
                          review: review,
                        ),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _reviewsFuture = _loadReviews();
                      });
                    }
                  },
                  onDelete: () => _deleteReview(id),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Tidak ada data yang tersedia.'),
            );
          }
        },
      ),
    );
  }
}

class ReviewListItem extends StatelessWidget {
  final Map<String, dynamic> review;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ReviewListItem({
    Key? key,
    required this.review,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Validasi key sebelum digunakan
    final title = review['title'] ?? 'Judul tidak tersedia';
    final rating = review['rating'] ?? 0;
    final comment = review['comment'] ?? 'Komentar tidak tersedia';

    return ListTile(
      title: Text(title),
      subtitle: Text('$rating / 10\n$comment'),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
