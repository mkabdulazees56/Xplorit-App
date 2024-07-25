import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/rented_vehicle_model.dart';
import 'package:xplorit/Repositories/rented_vehicle_repositories.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/utils/constants/colors.dart';

class RentedVehicleController extends GetxController {
  static RentedVehicleController get instance => Get.find();

  final isLoading = false.obs;
  final rentedvehicleRepository = Get.put(RentedVehicleRepository());
  RxList<RentedVehicleModel> rentedvehiclesData = <RentedVehicleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRentedVehicleData();
  }

  Future<void> fetchRentedVehicleData() async {
    try {
      isLoading.value = true;
      final rentedvehicles = await rentedvehicleRepository.getRentedVehicles();
      rentedvehiclesData.assignAll(rentedvehicles);
    } catch (e) {
      errorSnackBar(title: 'Oho Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeRentedVehicleData(String rentId) async {
    await rentedvehicleRepository.removeRentedVehicle(rentId);
    await fetchRentedVehicleData();
    // Get.offAll(() => Dashboard());
  }

  Future<void> addRentedVehicleData(
      RentedVehicleModel rentedvehicle, BuildContext context) async {
    await rentedvehicleRepository.AddRentedVehicle(rentedvehicle);
    await fetchRentedVehicleData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomelentPage()),
    );
  }

  Future<void> updateRentedVehicleData(
      String documentId, RentedVehicleModel rentedvehicle) async {
    rentedvehicleRepository.updateRentedVehicle(documentId, rentedvehicle);
    await fetchRentedVehicleData();
    Get.to(() => const HomelentPage());
  }

  // Future<List<String>> uploadRentedVehicleImage(images) async {
  //   // isLoading.value = true;
  //   try {
  //     final imageUrl = await rentedvehicleRepository.uploadImages(
  //         '/RentedVehicle/Images', images);
  //     return imageUrl;
  //   } catch (e) {
  //     return [];
  //   } finally {
  //     // isLoading.value = false;
  //   }
  // }

  // Future<List<String>> uploadRentedVehicleImage() async {
  //   isLoading.value = true;
  //   final images = await ImagePicker().pickMultiImage(
  //       // source: ImageSource.gallery,
  //       // imageQuality: 100,
  //       // maxHeight: 100,
  //       // maxWidth: 100
  //       );
  //   if (images.length > 4) {
  //     errorSnackBar(
  //         title: 'Oops!', message: 'You can select only up to 4 images.');
  //   } else if (images != null && images.isNotEmpty) {
  //     final imageUrl =
  //         await rentedvehicleRepository.uploadImages('/RentedVehicle/Images', images);
  //     return imageUrl;
  //   }
  //   return [];
  // }

  static errorSnackBar({required title, message = ' '}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: TColors.white),
    );
  }
}
