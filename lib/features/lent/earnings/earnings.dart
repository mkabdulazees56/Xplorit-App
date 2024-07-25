// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/completed_rent_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/completed_rent_model.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
// import 'package:xplorit/features/lent/AddVehicle/select_vehicle_type_widget.dart';
import 'package:xplorit/features/lent/earnings/earnings_vehicle_card_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({required this.garageId, Key? key}) : super(key: key);

  final String garageId;
  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  final completedRentController = Get.put(CompletedRentController());
  final renterController = Get.put(RenterController());
  final vehicleController = Get.put(VehicleController());
  final garageController = Get.put(GarageController());
  List<CompletedRentModel> completedRents = [];
  String garageName = 'Xpo Garage';
  String renterName = '';
  String renterImage = TImages.profile;
  String vehicleName = '';
  String vehicleImage = TImages.car;
  double totalEarning = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.renterId)
  Future<void> _initializeData() async {
    await fetchGarageName();
    await fetchCompletedRentData();
    await fetchCompletedRent();
    try {
      setState(() {});
    } catch (e) {}
  }

  Future<void> fetchCompletedRent() async {
    try {
      for (CompletedRentModel completedRent
          in completedRentController.completedRentsData) {
        if (completedRent.garageId == widget.garageId) {
          completedRents.add(completedRent);
          totalEarning = totalEarning + completedRent.earning;
        }
      }
    } catch (error) {}
  }

  Future<void> fetchCompletedRentData() async {
    await completedRentController.fetchCompletedRentData();
  }

  Future<void> fetchGarageName() async {
    for (GarageModel garage in garageController.garagesData) {
      if (garage.garageId == widget.garageId) {
        garageName = garage.userName;
      }
    }
  }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];

    for (var completedRent in completedRents) {
      for (RenterModel renter in renterController.rentersData) {
        if (renter.renterId == completedRent.renterId) {
          renterName = renter.userName;
          try {
            if (renter.profilePicture.isNotEmpty) {
              renterImage = renter.profilePicture;
            } else {
              renterImage = TImages.profile;
            }
          } catch (e) {
            renterImage = TImages.profile;
          }
        }
      }
      for (VehicleModel vehicle in vehicleController.vehiclesData) {
        if (vehicle.vehicleId == completedRent.vehicleId) {
          try {
            if (vehicle.vehicleImage.isNotEmpty &&
                vehicle.vehicleImage[0].isNotEmpty) {
              vehicleImage = vehicle.vehicleImage[0];
            } else {
              vehicleImage = TImages.car;
            }
          } catch (e) {
            vehicleImage = TImages.car;
          }
          vehicleName = vehicle.model;
        }
      }

      vehicleWidgets.add(
        EarningsVehicleCardWidgets(
          vehicleImg: vehicleImage,
          vehicleName: vehicleName,
          startDate: completedRent.startDate,
          endDate: completedRent.endDate,
          renderImg: renterImage,
          earning: completedRent.earning,
          renderImgScale: 8,
          renterName: renterName,
        ),
      );
      vehicleWidgets.add(SizedBox(height: 10));
    }

    return vehicleWidgets;
  }

  Widget vehicleList() {
    return Obx(() {
      if (completedRentController.isLoading.value) {
        return Column(
          children: [
            SizedBox(height: 15),
            Container(
              height: 150,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 150,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 150,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ],
        );
      } else if (completedRentController.completedRentsData.isEmpty) {
        return Center(child: Text('No Earnings'));
      } else {
        return FutureBuilder<List<Widget>>(
          future: _buildVehicleWidgets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Earnings'));
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: snapshot.data!,
              );
            }
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: TColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackButtonWidget(
                        btnColor: TColors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Earnings',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Rs : $totalEarning',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: TColors.white,
                            backgroundImage: AssetImage(TImages
                                .garageIcon), // Provide the path to your image
                          ),
                          SizedBox(width: 15),
                          Text(garageName.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Expanded(
                    // child:
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            vehicleList(),
                          ],
                        ),
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
