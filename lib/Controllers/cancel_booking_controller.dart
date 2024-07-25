import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/cancelled_booking_model.dart';
import 'package:xplorit/Repositories/cancelled_booking_repositories.dart';
// import 'package:xplorit/features/product/cancelledbooking_details.dart';
import 'package:xplorit/utils/constants/colors.dart';

class CancelledBookingController extends GetxController {
  static CancelledBookingController get instance => Get.find();

  final isLoading = false.obs;
  final cancelledbookingRepository = Get.put(CancelledBookingRepository());
  RxList<CancelledBookingModel> cancelledbookingsData =
      <CancelledBookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCancelledBookingData();
  }

  Future<void> fetchCancelledBookingData() async {
    try {
      isLoading.value = true;
      final cancelledbookings =
          await cancelledbookingRepository.getCancelledBookings();
      cancelledbookingsData.assignAll(cancelledbookings);
    } catch (e) {
      errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  addCancelledBookingData(CancelledBookingModel cancelledbooking) async {
    await cancelledbookingRepository.AddCancelledBooking(cancelledbooking);
    await fetchCancelledBookingData();
  }

  removeCancelledBookingData(String bookingId) async {
    await cancelledbookingRepository.removeCancelledBooking(bookingId);
    await fetchCancelledBookingData();
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
