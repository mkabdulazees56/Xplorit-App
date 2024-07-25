import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Repositories/renter_repositories.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
// import 'package:xplorit/features/product/renter_details.dart';
import 'package:xplorit/utils/constants/colors.dart';

class RenterController extends GetxController {
  static RenterController get instance => Get.find();

  final isLoading = false.obs;
  final renterRepository = Get.put(RenterRepository());
  RxList<RenterModel> rentersData = <RenterModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRenterData();
  }

  // void fetchRenterData() async {
  //   try {
  //     isLoading.value = true;

  //     final renters = await renterRepository.getRenters();

  //     rentersData.assignAll(renters);
  //   } catch (e) {
  //     errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //     isLoading.value = false;
  //   } finally {}
  // }

  Future<void> fetchRenterData() async {
    try {
      isLoading.value = true;
      final renters = await renterRepository.getRenters();
      rentersData.assignAll(renters);
    } catch (e) {
      errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRenterActiveStatus(
      String documentId, bool isRenterActive) async {
    await renterRepository.updateRenterActiveStatus(documentId, isRenterActive);
    await fetchRenterData();
    // Get.to(() => const HomelentPage());
  }

  Future<void> updateRenterReview(
      String documentId, double rating, int noOfRating) async {
    await renterRepository.updateRenterReview(documentId, rating, noOfRating);
    await fetchRenterData();
    // Get.to(() => const HomelentPage());
  }

  Future<void> addRenterData(RenterModel renter) async {
    await renterRepository.AddRenter(renter);
    await fetchRenterData();
    Get.offAll(() => const Dashboard());
  }

  Future<void> updateRenterData(String documentId, RenterModel renter) async {
    await renterRepository.updateRenter(documentId, renter);
    Get.offAll(() => const Dashboard());
  }

  updateRenterLocation(String documentId, double latitude, double longitude,
      Timestamp timeStamp) {
    renterRepository.updateRenterLocation(
        documentId, latitude, longitude, timeStamp);
  }

  Future<void> removeRenterData(String renterId) async {
    await renterRepository.RemoveRenter(renterId);
  }

  Future<String> uploadProfilePicture(image) async {
    try {
      final imageUrl =
          await renterRepository.uploadImage('/Renter/Profile', image);
      return imageUrl;
    } catch (e) {
      Get.snackbar('Oops Controller!', e.toString());
      return '';
    }
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
      duration: const Duration(seconds: 50),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: TColors.white),
    );
  }
}
