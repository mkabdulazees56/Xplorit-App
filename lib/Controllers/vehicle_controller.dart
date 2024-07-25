import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/Repositories/vehicle_repositories.dart';
import 'package:xplorit/features/lent/AddVehicle/show_vehicle_details.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/utils/constants/colors.dart';

class VehicleController extends GetxController {
  static VehicleController get instance => Get.find();

  // Rx<VehicleModel> vehicle = VehicleModel.empty().obs;
  final isLoading = false.obs;
  final vehicleRepository = Get.put(VehicleRepository());
  RxList<VehicleModel> vehiclesData = <VehicleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicleData();
  }

  Future<void> fetchVehicleData() async {
    try {
      isLoading.value = true;
      final vehicles = await vehicleRepository.getVehicles();
      vehiclesData.assignAll(vehicles);
    } catch (e) {
      errorSnackBar(title: 'Oho Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addVehicleData(
      VehicleModel vehicle, BuildContext context) async {
    String vId = await vehicleRepository.AddVehicle(vehicle);
    // Get.put(VehicleController());

    await fetchVehicleData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ShowVehicleDetails(
                vehicleId: vId,
              )),
    );
  }

  Future<void> updateVehicleData(
      String documentId, VehicleModel vehicle) async {
    await vehicleRepository.updateVehicle(documentId, vehicle);
    await fetchVehicleData();
    Get.to(() => const HomelentPage());
  }

  Future<void> removeVehicleData(String vehicleId) async {
    await vehicleRepository.removeVehicle(vehicleId);
    await fetchVehicleData();
    Get.to(() => const HomelentPage());
  }

  Future<void> updateVehicleActiveStatus(
      String documentId, bool isVehicleActive) async {
    await vehicleRepository.updateVehicleActiveStatus(
        documentId, isVehicleActive);
    await fetchVehicleData();
    // Get.to(() => const HomelentPage());
  }

  Future<void> updateVehicleReview(
      String documentId, double rating, int noOfRating) async {
    await vehicleRepository.updateVehicleReview(documentId, rating, noOfRating);
    await fetchVehicleData();
    // Get.to(() => const HomelentPage());
  }

  Future<List<String>> uploadVehicleImage(images) async {
    // isLoading.value = true;
    try {
      final imageUrl =
          await vehicleRepository.uploadImages('/Vehicle/Images', images);
      return imageUrl;
    } catch (e) {
      return [];
    } finally {
      // isLoading.value = false;
    }
  }

  static void errorSnackBar({required String title, String message = ' '}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });
  }
}
