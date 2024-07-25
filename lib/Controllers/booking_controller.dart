import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Repositories/Booking_repositories.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
// import 'package:xplorit/features/product/booking_details.dart';
import 'package:xplorit/utils/constants/colors.dart';

class BookingController extends GetxController {
  static BookingController get instance => Get.find();

  final isLoading = false.obs;
  final bookingRepository = Get.put(BookingRepository());
  RxList<BookingModel> bookingsData = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingData();
  }

  Future<void> fetchBookingData() async {
    try {
      isLoading.value = true;
      final bookings = await bookingRepository.getBookings();
      bookingsData.assignAll(bookings);
    } catch (e) {
      errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  addBookingData(BookingModel booking) async {
    await bookingRepository.AddBooking(booking);
    await fetchBookingData();
    Get.offAll(() => Dashboard());
  }

  removeBookingData(String bookingId) async {
    await bookingRepository.removeBooking(bookingId);
    await fetchBookingData();
    // Get.to(() => Dashboard());
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
