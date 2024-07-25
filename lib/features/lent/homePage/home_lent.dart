// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/cancel_booking_controller.dart';
import 'package:xplorit/Controllers/completed_rent_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/features/Lender_chat/chat_home_page.dart';
import 'package:xplorit/features/dashbord/dash_board_header_widget.dart';
import 'package:xplorit/features/lent/AddVehicle/select_vehicle_type.dart';
import 'package:xplorit/features/lent/AddVehicle/show_vehicle_details.dart';
import 'package:xplorit/features/lent/earnings/earnings.dart';
import 'package:xplorit/features/lent/garage/mygarage.dart';
import 'package:xplorit/features/lent/homePage/select_actions.dart';
import 'package:xplorit/features/lent/homePage/show_otp_page.dart';
import 'package:xplorit/features/lent/homePage/your_vehicle.dart';
import 'package:xplorit/features/lent/lender_profile/lender_profile_home.dart';
import 'package:xplorit/features/lent/lent_orders/lent_orders.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class HomelentPage extends StatefulWidget {
  const HomelentPage({Key? key}) : super(key: key);

  @override
  State<HomelentPage> createState() => _HomelentPageState();
}

class _HomelentPageState extends State<HomelentPage> {
  String garageId = '';
  String vehicleId = '';
  String renterId = '';
  String defaultVehicleImage = '';
  int bottomNavBarCurrentIndex = 0;
  final String locationName = "unknown";
  final renterController = Get.put(RenterController());
  final garageController = Get.put(GarageController());
  final bookingController = Get.put(BookingController());
  final vehicleController = Get.put(VehicleController());
  final cancelledBookingController = Get.put(CancelledBookingController());
  final rentedVehicleController = Get.put(RentedVehicleController());
  final completedRentController = Get.put(CompletedRentController());

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _initializeDataAndListen();
    // _initializeData();
  }

  Future<void> _initializeDataAndListen() async {
    await _initializeData().then((_) {
      _listenForOtp();
    });
  }

  void _listenForOtp() async {
    try {
      print('entered');
      if (mounted) {
        print('entered II');
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && garageId != '' && garageId.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('otps')
              .doc(garageId)
              .snapshots()
              .listen((snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              // Extract the vehicle ID from the snapshot
              var data = snapshot.data();
              vehicleId = data?['vehicleId'];
              renterId = data?['renterId'];
              print('entered III');

              Get.to(() => ShowOtpPage(
                  renterId: renterId,
                  vehicleId: vehicleId,
                  garageId: garageId)); // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ShowOtpPage(
              //         renterId: renterId,
              //         vehicleId: vehicleId,
              //         garageId: garageId),
              //   ),
              // );
            }
          });
        }
      }
    } catch (e) {}
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await fetchGarageId();
    await fetchGarageData();
    await fetchVehicleData();
    await fetchRenterData();
    await fetchBookingData();
    await fetchRentedVehicleData();
  }

  Future<void> fetchRentedVehicleData() async {
    await rentedVehicleController.fetchRentedVehicleData();
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchVehicleData() async {
    await vehicleController.fetchVehicleData();
  }

  Future<void> fetchRenterData() async {
    await renterController.fetchRenterData();
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchBookingData() async {
    await bookingController.fetchBookingData();
  }

  // Asynchronous method to fetch garage data
  Future<void> fetchGarageData() async {
    await garageController.fetchGarageData();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _requestLocationPermission();
        });
      }
    }
  }

  Future<void> fetchGarageId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userPhoneNumber = user.phoneNumber ?? '';
      try {
        // for(GarageModel garage in garageController.garagesData){
        //   if(garage.contactNumber == userPhoneNumber){
        //     garageId = garage.garageId;
        //   }
        // }
        if (mounted) {
          setState(() {
            var matchingGarage = garageController.garagesData.firstWhere(
              (garage) => garage.contactNumber == userPhoneNumber,
            );

            garageId =
                matchingGarage != null && matchingGarage.garageId.isNotEmpty
                    ? matchingGarage.garageId
                    : '';
          });
        }
      } catch (e) {}
    }
  }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];
    List<double> allRatings = [];

    int vehicleCount = 0; // Counter to keep track of added vehicles

    // controller.vehiclesData.sort((a, b) => b.rating.compareTo(a.rating));

    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      if (garageId == vehicle.garageId) {
        // String defaultVehicleImage;
        try {
          if (vehicle.vehicleImage.isNotEmpty &&
              vehicle.vehicleImage[0].isNotEmpty) {
            defaultVehicleImage = vehicle.vehicleImage[0];
          } else {
            defaultVehicleImage = TImages.car;
          }
        } catch (e) {
          defaultVehicleImage = TImages.car;
        }

        vehicleWidgets.add(
          YourVehicle(
            vehicleImg: defaultVehicleImage,
            title: vehicle.model,
            tapCal: () {
              Get.to(() => ShowVehicleDetails(vehicleId: vehicle.vehicleId));
            },
          ),
        );
        vehicleWidgets.add(SizedBox(width: 10));

        vehicleCount++;

        if (vehicleCount >= 3) {
          break;
        }
      }
    }

    return vehicleWidgets;
  }

  Widget vehicleList() {
    return Obx(() {
      if (vehicleController.isLoading.value) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(child: CircularProgressIndicator()),
          ],
        ));
      } else if (vehicleController.vehiclesData.isEmpty) {
        return Text('No vehicles available');
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
              return Text('No vehicles available');
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: snapshot.data!.map((widget) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.50),
                      child: widget,
                    );
                  }).toList(),
                ),
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
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashBoardHeaderWidget(
                  profilelogo: TImages.garageIcon,
                  tapCal: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LenderProfileHomePage()),
                    );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Vehicles',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    vehicleList(),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SelectActions(
                            vehicleImg: TImages.addVehicleIcon,
                            title: 'Add Vehicle',
                            tapCal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectVehicleType()),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: SelectActions(
                            vehicleImg: TImages.earnIcon,
                            title: 'Earnings',
                            tapCal: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => LenderChatHomePage()),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EarningsPage(
                                          garageId: garageId,
                                        )),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SelectActions(
                            vehicleImg: TImages.orderIcon,
                            title: 'Orders',
                            tapCal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LentOrders(garageId: garageId)),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: SelectActions(
                            vehicleImg: TImages.garageIcon,
                            title: 'My Garage',
                            tapCal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyGaragePage()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavBarCurrentIndex,
        unselectedItemColor: TColors.greyDark,
        selectedItemColor: TColors.primary,
        backgroundColor: TColors.blueLight,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        onTap: (index) {
          setState(() {
            bottomNavBarCurrentIndex = index;
          });
          switch (index) {
            case 0:
              Get.offAll(() => HomelentPage());
              break;
            case 1:
              Get.offAll(() => LenderChatHomePage());
              break;
            case 2:
              Get.offAll(() => LenderProfileHomePage());
              break;
          }
        },
      ),
    );
  }
}
