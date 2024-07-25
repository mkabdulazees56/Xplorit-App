import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Repositories/garage_repositories.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/utils/constants/colors.dart';

class GarageController extends GetxController {
  static GarageController get instance => Get.find();

  final isLoading = false.obs;
  final garageRepository = Get.put(GarageRepository());
  RxList<GarageModel> garagesData = <GarageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
// Defer state-changing operations to after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGarageData();
    });
  }

  Future<void> fetchGarageData() async {
    try {
      // Update isLoading to true before fetching data
      isLoading.value = true;

      // Fetch data asynchronously
      final garages = await garageRepository.getGarages();

      // Update garagesData with fetched data
      garagesData.assignAll(garages);
    } catch (e) {
      // Handle errors gracefully
      Get.snackbar(
        'Oops!',
        e.toString(),
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: TColors.white),
      );
    } finally {
      // Ensure isLoading is set to false after fetching data
      isLoading.value = false;
    }
  }

  Future<void> addGarageData(GarageModel garage) async {
    await garageRepository.AddGarage(garage);
    Get.to(const HomelentPage());
  }

  Future<void> removeGarageData(String garageId) async {
    await garageRepository.RemoveGarage(garageId);
  }

  Future<void> updateGarageData(String documentId, GarageModel garage) async {
    try {
      // Update the garage data
      await garageRepository.updateGarage(documentId, garage);
      // Update the UI to indicate loading
      isLoading.value = true;
      // Fetch the updated garage data
      await fetchGarageData();
      // Navigate to the HomeLentPage
      Get.to(const HomelentPage());
    } catch (e) {
      // Handle errors gracefully
      Get.snackbar(
        'Oops!',
        e.toString(),
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: TColors.white),
      );
    } finally {
      // Ensure isLoading is set to false after fetching data
      isLoading.value = false;
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
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: TColors.white),
    );
  }
}
