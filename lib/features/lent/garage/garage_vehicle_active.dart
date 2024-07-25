// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/features/lender_review/lender_review_page.dart';
import 'package:xplorit/features/lent/AddVehicle/update_car_details_form.dart';
import 'package:xplorit/features/lent/garage/garage_vehicle_actions_widgets.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class MyGaragePageActive extends StatefulWidget {
  const MyGaragePageActive({
    required this.vehicleId,
    required this.model,
    required this.rating,
    required this.defaultVehicleImage,
    required this.isVehicleActive,
    Key? key,
  }) : super(key: key);

  final String vehicleId;
  final String model;
  final String defaultVehicleImage;
  final String rating;
  final bool isVehicleActive;

  @override
  State<MyGaragePageActive> createState() => _MyGaragePageActiveState();
}

class _MyGaragePageActiveState extends State<MyGaragePageActive> {
  bool isSwitched = false;
  String switchText = 'Dectivate';
  final vehicleController = Get.put(VehicleController());
  String renterId = 'x5zbua2zXR8zynzy8CFr';
  String vehicleId = '';
  String garageId = '';
  String model = '';
  String mileage = '';
  String pickupLocation = '';
  String fuelType = '';
  String transmission = '';
  String vehicleType = '';
  int seatingCapacity = 0;
  double rentalRate = 0.0;
  String rentalRateType = '';
  bool isVehicleActive = true;
  double rating = 0.0;
  int noOfRating = 0;
  List<String> vehicleImage = [];
  List<String> rules = [];
  List<String> extraFeatures = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchVehicleData();
  }

  Future<void> fetchVehicleData() async {
    // await vehicleController.fetchVehicleData();
    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      if (widget.vehicleId == vehicle.vehicleId) {
        vehicleId = widget.vehicleId;
        vehicleId = vehicle.vehicleId;
        model = vehicle.model;
        garageId = vehicle.garageId;
        mileage = vehicle.mileage;
        seatingCapacity = vehicle.seatingCapacity!;
        rentalRate = vehicle.rentalRates;
        isVehicleActive = vehicle.isVehicleActive;
        rating = vehicle.rating;
        noOfRating = vehicle.noOfRating;
        rentalRateType = vehicle.rentalRateType;
        extraFeatures = vehicle.extraFeatures;
        rules = vehicle.rules;
        vehicleImage = vehicle.vehicleImage;
        fuelType = vehicle.fuelType;
        pickupLocation = vehicle.pickupLocation;
        transmission = vehicle.transmission;
        vehicleType = vehicle.vehicleType;
      }
    }
  }

  void updateVehicleData(
    String vehicleId,
    String garageId,
    String model,
    String mileage,
    String pickupLocation,
    String fuelType,
    String transmission,
    String vehicleType,
    int seatingCapacity,
    double rentalRate,
    String rentalRateType,
    bool isVehicleActive,
    double rating,
    int noOfRating,
    List<String> vehicleImage,
    List<String> rules,
    List<String> extraFeatures,
  ) {
    final vehicle = VehicleModel(
      vehicleId: vehicleId,
      garageId: garageId,
      model: model,
      mileage: mileage,
      pickupLocation: pickupLocation,
      fuelType: fuelType,
      transmission: transmission,
      vehicleType: vehicleType,
      seatingCapacity: seatingCapacity,
      rentalRates: rentalRate,
      rentalRateType: rentalRateType,
      isVehicleActive: isVehicleActive,
      rating: rating,
      noOfRating: noOfRating,
      rules: rules,
      extraFeatures: extraFeatures,
      vehicleImage: vehicleImage,
    );
    VehicleController.instance.updateVehicleData(vehicleId, vehicle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: TColors.primary,
        child: SafeArea(
          child: SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.model,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          Container(
                            width: 100,
                            height: 40,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                'Active',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.apply(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      IconTextWidget(
                        icon: Icons.star,
                        txt: widget.rating,
                        colorIcon: Colors.yellow,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: widget.defaultVehicleImage.startsWith('http')
                              ? Image.network(
                                  widget.defaultVehicleImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.person,
                                        color: TColors.secondary,
                                        size: 60,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  widget.defaultVehicleImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.person,
                                        color: TColors.secondary,
                                        size: 60,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    Container(
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
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: TColors.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: // Inside your build method
                                    Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          switchText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                        Text(
                                          'By deactivating this vehicle will \n be removed from listing',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                          isVehicleActive = !isSwitched;
                                        });
                                        updateVehicleData(
                                          vehicleId,
                                          garageId,
                                          model,
                                          mileage,
                                          pickupLocation,
                                          fuelType,
                                          transmission,
                                          vehicleType,
                                          seatingCapacity,
                                          rentalRate,
                                          rentalRateType,
                                          isVehicleActive,
                                          rating,
                                          noOfRating,
                                          vehicleImage,
                                          rules,
                                          extraFeatures,
                                        );
                                      },
                                      activeColor: TColors.primary,
                                      inactiveThumbColor: TColors.darkGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            VehicleActionsWidget(
                              title: "Modify",
                              iconImg: TImages.settingsIcon,
                              tapCal: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateCarDetails(
                                        vehicleId: widget.vehicleId),
                                  ),
                                );
                              },
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // VehicleActionsWidget(
                            //   title: "Track the vehicle",
                            //   iconImg: TImages.trackVehicleIcon,
                            //   tapCal: () {
                            //     Get.to(
                            //       () => TrackVehiclePage(
                            //         model: widget.model,
                            //         renterId: renterId,
                            //         renterImage: 'TImage.profile',
                            //         renterName: 'Nane Varuven',
                            //         defaultVehicleImage:
                            //             widget.defaultVehicleImage,
                            //       ),
                            //     );
                            //   },
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            VehicleActionsWidget(
                              title: "Reviews",
                              iconImg: TImages.reviewsIcon,
                              tapCal: () {
                                Get.to(() => LenderReviewPage(
                                      editMode: false,
                                      productId: vehicleId,
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
