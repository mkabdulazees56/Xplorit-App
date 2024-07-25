import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String reviewId;
  String productId;
  String raterId;
  double rating;
  Timestamp timestamp;
  String review;

  ReviewModel({
    required this.productId,
    required this.reviewId,
    required this.raterId,
    required this.rating,
    required this.review,
    required this.timestamp,
  });

  toJson() {
    return {
      'reviewId': reviewId,
      'productId': productId,
      'raterId': raterId,
      'rating': rating,
      'review': review,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  static ReviewModel empty() => ReviewModel(
        reviewId: '',
        productId: '',
        raterId: '',
        review: '',
        rating: 0.0,
        timestamp: Timestamp.now(),
      );

  factory ReviewModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return ReviewModel.empty();
    final data = document.data();
    return ReviewModel(
      reviewId: data?['reviewId'] ?? '',
      productId: data?['productId'] ?? '',
      raterId: data?['raterId'] ?? '',
      review: data?['review'] ?? '',
      rating: data?['rating'] ?? 0.0,
      timestamp: data?['timestamp'] ?? Timestamp.now(),
    );
  }
}
