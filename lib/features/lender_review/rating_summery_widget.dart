// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/features/lender_review/lender_review_item.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class LenderRatingSummary extends StatefulWidget {
  const LenderRatingSummary({required this.productId, super.key});

  final String productId;
  @override
  State<LenderRatingSummary> createState() => _LenderRatingSummaryState();
}

class _LenderRatingSummaryState extends State<LenderRatingSummary> {
  final vehicleController = Get.put(VehicleController());
  final renterController = Get.put(RenterController());
  String defaultVehicleImage = TImages.car;
  double rating = 0.0;
  int noOfRating = 0;
  bool isVehicle = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchProductData();
  }

  Future<void> fetchProductData() async {
    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      if (vehicle.vehicleId == widget.productId) {
        rating = vehicle.rating;
        noOfRating = vehicle.noOfRating;
        isVehicle = true;
      }
    }
    if (!isVehicle) {
      for (RenterModel renter in renterController.rentersData) {
        if (renter.renterId == widget.productId) {
          rating = renter.rating;
          noOfRating = renter.noOfRating;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rating.toString(),
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            StarDisplay(value: rating),
            Spacer(),
            Text(
              '$noOfRating Reviews',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
