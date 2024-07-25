// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class LenderProductInfo extends StatefulWidget {
  const LenderProductInfo({required this.productId, super.key});

  final String productId;

  @override
  State<LenderProductInfo> createState() => _LenderProductInfoState();
}

class _LenderProductInfoState extends State<LenderProductInfo> {
  final vehicleController = Get.put(VehicleController());
  final renterController = Get.put(RenterController());
  String defaultProductImage = TImages.car;
  String productName = '';
  double rating = 0.01;
  int noOfRating = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchProductData();
  }

  Future<void> fetchProductData() async {
    bool productIsVehicle = false;

    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      if (vehicle.vehicleId == widget.productId) {
        try {
          if (vehicle.vehicleImage.isNotEmpty &&
              vehicle.vehicleImage[0].isNotEmpty) {
            defaultProductImage = vehicle.vehicleImage[0];
          } else {
            defaultProductImage = TImages.car;
          }
        } catch (e) {
          defaultProductImage = TImages.car;
        }
        productName = vehicle.model;
        rating = vehicle.rating;
        noOfRating = vehicle.noOfRating;
        productIsVehicle = true;
        // break;
      }
    }

    if (!productIsVehicle) {
      for (RenterModel renter in renterController.rentersData) {
        if (renter.renterId == widget.productId) {
          try {
            if (renter.profilePicture.isNotEmpty) {
              defaultProductImage = renter.profilePicture;
            } else {
              defaultProductImage = TImages.profile;
            }
          } catch (e) {
            defaultProductImage = TImages.profile;
          }
          productName = renter.userName;
          rating = renter.rating;
          noOfRating = renter.noOfRating;
          productIsVehicle = true;
          // break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: TColors.secondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(productName, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 4.0),
                  Text(
                    '$rating ($noOfRating reviews)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: defaultProductImage.startsWith('http')
                ? Image.network(
                    defaultProductImage,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              TImages.car,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Image.asset(
                    defaultProductImage,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              TImages.car,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Image.asset(
          //   TImages.autoBajaj,
          //   width: 80,
          //   height: 80,
          //   fit: BoxFit.cover,
          // ),
        ],
      ),
    );
  }
}
