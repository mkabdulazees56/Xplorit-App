import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/payment_model.dart';
import 'package:xplorit/Repositories/payment_repositories.dart';
// import 'package:xplorit/features/product/payment_details.dart';
import 'package:xplorit/utils/constants/colors.dart';

class PaymentController extends GetxController {
  static PaymentController get intance => Get.find();

  final isLoading = false.obs;
  final paymentRepository = Get.put(PaymentRepository());
  RxList<PaymentModel> paymentsData = <PaymentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentData();
  }

  // void fetchPaymentData() async {
  //   try {
  //     isLoading.value = true;

  //     final payments = await paymentRepository.getPayments();

  //     paymentsData.assignAll(payments);
  //   } catch (e) {
  //     errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //     isLoading.value = false;
  //   } finally {}
  // }

  void fetchPaymentData() async {
    try {
      isLoading.value = true;
      final payments = await paymentRepository.getPayments();
      paymentsData.assignAll(payments);
      Get.snackbar(
        'Hey!!!',
        'Fetched and Assigned ${payments.length} payments',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 0, 0, 255),
      );
    } catch (e) {
      errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e.toString());
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  addPaymentData(PaymentModel payment) {
    paymentRepository.AddPayment(payment);
    // Get.to(PaymentDetails());
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
