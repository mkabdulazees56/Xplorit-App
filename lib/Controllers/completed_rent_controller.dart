import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/completed_rent_model.dart';
import 'package:xplorit/Repositories/completed_rent_repositories.dart';
// import 'package:xplorit/features/product/CompletedRent_details.dart';
import 'package:xplorit/utils/constants/colors.dart';

class CompletedRentController extends GetxController {
  static CompletedRentController get instance => Get.find();

  final isLoading = false.obs;
  final completedRentRepository = Get.put(CompletedRentRepository());
  RxList<CompletedRentModel> completedRentsData = <CompletedRentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompletedRentData();
  }

  Future<void> fetchCompletedRentData() async {
    try {
      isLoading.value = true;
      final completedRents = await completedRentRepository.getCompletedRents();
      completedRentsData.assignAll(completedRents);
    } catch (e) {
      errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  addCompletedRentData(CompletedRentModel CompletedRent) async {
    await completedRentRepository.AddCompletedRent(CompletedRent);
    await fetchCompletedRentData();
  }

  removeCompletedRentData(String bookingId) async {
    await completedRentRepository.removeCompletedRent(bookingId);
    await fetchCompletedRentData();
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
