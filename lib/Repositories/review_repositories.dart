import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Models/review_model.dart';
import 'package:xplorit/utils/constants/colors.dart';

class ReviewRepository extends GetxController {
  static ReviewRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<ReviewModel>> getReviews() async {
    try {
      final snapshot = await _db.collection('Review').get();
      //.where('transmission', isEqualTo: 'Manual').limit(4);
      if (snapshot == null) {
        return [];
      } else {
        List<ReviewModel> reviews = snapshot.docs.map((doc) {
          return ReviewModel.fromSnapshot(doc);
        }).toList();
        return reviews;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw ' Something went wrong. Please try again \n $e';
    }
  }

  Future<void> updateReview(String documentId, ReviewModel review) async {
    DocumentReference docRef = _db.collection('Review').doc(documentId);

    await docRef.update(review.toJson()).then((_) {
      Get.snackbar('Success', 'Review data updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color.fromARGB(255, 255, 255, 255),
          backgroundColor: TColors.primary);
    }).catchError((error) {
      // Show error snackbar if updating fails
      Get.snackbar(
        'Error',
        'Failed to update Review',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }

  Future<void> AddReview(ReviewModel review) async {
    try {
      DocumentReference ref =
          await _db.collection('Review').add(review.toJson());
      String rId = ref.id;

      review.reviewId = rId;

      await ref.update({'reviewId': rId});
      Get.snackbar(
        'Success',
        'Review added successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );
    } catch (error) {
      // Show error snackbar if adding or updating fails
      Get.snackbar(
        'Error',
        'Something went wrong \n $error',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  }
}
