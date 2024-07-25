import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/review_model.dart';
import 'package:xplorit/Repositories/review_repositories.dart';
// import 'package:xplorit/features/product/review_details.dart';
import 'package:xplorit/utils/constants/colors.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final isLoading = false.obs;
  final reviewRepository = Get.put(ReviewRepository());
  RxList<ReviewModel> reviewsData = <ReviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviewData();
  }

  Future<void> fetchReviewData() async {
    try {
      isLoading.value = true;
      final reviews = await reviewRepository.getReviews();
      reviewsData.assignAll(reviews);
    } catch (e) {
      errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  addReviewData(ReviewModel review) async {
    await reviewRepository.AddReview(review);
    await fetchReviewData();
    // Get.offAll(() => Dashboard());
  }

  static errorSnackBar({required title, message = ' '}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: TColors.white),
    );
  }
}
