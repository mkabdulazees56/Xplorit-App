// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/vehicle_model.dart';
// ignore: unused_import
import 'package:xplorit/Repositories/vehicle_repositories.dart';
import 'package:xplorit/features/Renter_chat/renter_chat_home_page.dart';
import 'package:xplorit/features/booking_status/my_bookings.dart';
import 'package:xplorit/features/dashbord/dash_board_header_widget.dart';
import 'package:xplorit/features/dashbord/renter_profile/renter_profile_home.dart';
import 'package:xplorit/features/dashbord/search_bar_widget.dart';
import 'package:xplorit/features/dashbord/vehicle_label_widget.dart';
import 'package:xplorit/features/dashbord/vehicle_select_filter_widget.dart';
import 'package:xplorit/features/product/product_list.dart';
import 'package:xplorit/features/product/vehicle_details.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class Dashboard extends StatefulWidget {
  // final String locationName;
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _Home();
}

class _Home extends State<Dashboard> {
  int currentIndex = 0;
  int bottomNavBarCurrentIndex = 0;
  String firstVehicleImage = TImages.car;
  String profilePicture = TImages.profile;
  String renterId = '';
  Timer? _timer;

  final controller = Get.put(VehicleController());
  final garageController = Get.put(GarageController());
  final renterController = Get.put(RenterController());
  final rentedVehicleController = Get.put(RentedVehicleController());
  final bookingController = Get.put(BookingController());

  bool hasUnreadMessages = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _initializeDataAndListen();
    _startUpdatingLocation();
  }

  Future<void> _initializeDataAndListen() async {
    await _initializeData();
  }

  Future<void> _saveLocation(Position position) async {
    renterController.updateRenterLocation(
        renterId, position.latitude, position.longitude, Timestamp.now());
  }

  void _updateLocation() async {
    try {
      Position position = await _determinePosition();
      _saveLocation(position);
    } catch (e) {
      print("Failed to get location: $e");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    // Check if location permissions are permanently denied
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Fetch the current position with desired accuracy
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best, // Specify the desired accuracy
    );
  }

  void _startUpdatingLocation() {
    _timer =
        Timer.periodic(Duration(seconds: 59), (Timer t) => _updateLocation());
  }

  Future<void> _initializeData() async {
    await fetchProfilePicture();
    await fetchGarageData();
    await fetchVehicleData();
    await fetchRenterId();
    await fetchRentedVehicleData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchVehicleData() async {
    await controller.fetchVehicleData();
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchRentedVehicleData() async {
    await rentedVehicleController.fetchRentedVehicleData();
  }

  // Asynchronous method to fetch garage data
  Future<void> fetchGarageData() async {
    await garageController.fetchGarageData();
  }

  Future<void> fetchRenterId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userPhoneNumber = user.phoneNumber ?? '';
      try {
        if (mounted) {
          setState(() {
            var currentRenter = renterController.rentersData.firstWhere(
              (renter) => renter.contactNumber == userPhoneNumber,
              // orElse: () => RenterModel,
            );

            renterId =
                currentRenter != null && currentRenter.renterId.isNotEmpty
                    ? currentRenter.renterId
                    : '';
          });
        }
      } catch (e) {
        try {
          if (mounted) {
            var currentRenter = renterController.rentersData.firstWhere(
              (renter) => renter.contactNumber == userPhoneNumber,
              // orElse: () => RenterModel,
            );

            renterId =
                currentRenter != null && currentRenter.renterId.isNotEmpty
                    ? currentRenter.renterId
                    : '';
          }
        } catch (e) {
          renterId = '';
        }
      }
    }
  }

  // Asynchronous method to fetch renter data and update profile picture
  Future<void> fetchProfilePicture() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userPhoneNumber = user.phoneNumber ?? '';

      await renterController.fetchRenterData();
      try {
        if (mounted) {
          setState(() {
            var matchingRenter = renterController.rentersData.firstWhere(
              (renter) => renter.contactNumber == userPhoneNumber,
              // orElse: () => RenterModel,
            );

            profilePicture = matchingRenter != null &&
                    matchingRenter.profilePicture.isNotEmpty
                ? matchingRenter.profilePicture
                : TImages.profile;
          });
        }
      } catch (e) {
        profilePicture = TImages.profile;
      }
    }
  }
  // Method to initialize data

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];
    List<double> allRatings = [];
    List<double> firstSixRatings = [];

    for (VehicleModel vehicle in controller.vehiclesData) {
      if (vehicle.isVehicleActive) {
        allRatings.add(vehicle.rating);
      }
    }
    if (allRatings.length < 7) {
      int elementsToAdd = 7 - allRatings.length;
      for (int i = 0; i < elementsToAdd; i++) {
        allRatings.add(0.0);
      }
    }
    allRatings.sort((a, b) => b.compareTo(a));
    firstSixRatings = allRatings.take(6).toList();

    // controller.vehiclesData.sort((a, b) => b.rating.compareTo(a.rating));

    for (VehicleModel vehicle in controller.vehiclesData) {
      if (vehicle.isVehicleActive) {
        double distance = await calculateDistance(vehicle.pickupLocation);
        for (int i = 0; i < firstSixRatings.length; i++) {
          if (vehicle.rating == firstSixRatings[i] && distance <= 15
              // && firstSixRatings[i] != 0.0
              ) {
            try {
              if (vehicle.vehicleImage.isNotEmpty &&
                  vehicle.vehicleImage[0].isNotEmpty) {
                firstVehicleImage = vehicle.vehicleImage[0];
              } else {
                // firstVehicleImage = 'http';
                firstVehicleImage = TImages.car;
              }
            } catch (e) {
              firstVehicleImage = TImages.car;
            }

            vehicleWidgets.add(
              VehicleLabelWidget(
                vehicleTitle: vehicle.model,
                vehicleImage: firstVehicleImage,
                rating: vehicle.rating,
                noOfRating: vehicle.noOfRating,
                distance: '${distance.toStringAsFixed(2)} km',
                price: '${vehicle.rentalRates} PKR ${vehicle.rentalRateType}',
                onTapCall: () {
                  Get.to(VehicleDetails(vehicleId: vehicle.vehicleId));
                },
              ),
            );
            vehicleWidgets.add(SizedBox(width: 10));
            break;
          }
        }
      }
    }

    return [
      SizedBox(
        width: double.infinity,
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: vehicleWidgets,
            ),
          ],
        ),
      )
    ];
  }

  Widget vehicleList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ));
      } else if (controller.vehiclesData.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No Vehicles to Display'),
          ],
        );
      } else {
        return FutureBuilder<List<Widget>>(
          future: _buildVehicleWidgets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              print('Error:::::::${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No vehicles available');
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!,
              );
            }
          },
        );
      }
    });
  }

  Future<double> calculateDistance(String locationName) async {
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<String> coordinates = locationName.split(',');
    double longitude = double.parse(coordinates[0]);
    double latitude = double.parse(coordinates[1]);

    double distanceInMeters = await Geolocator.distanceBetween(latitude,
        longitude, currentPosition.latitude, currentPosition.longitude);

    double distanceInKm = distanceInMeters / 1000;
    return distanceInKm;
  }

  final CarouselController carouselController = CarouselController();

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

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    Future<String?> getToken() async {
      return await user?.getIdToken();
    }

    Future<void> tokenFun() async {
      String? token = await getToken();
      print('Token type: ${token.runtimeType}');

      print('token: $token');

      if (token == null) {
        Get.snackbar(
          token.toString(),
          controller.vehiclesData.length.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color(0xff00FF00),
        );
      } else {
        Get.snackbar(
          '${token.runtimeType}',
          token,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.pink,
          backgroundColor: Colors.white,
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // padding: const EdgeInsets.all(TSizes.defaultSpace),
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                StreamBuilder<Object>(
                    stream: null,
                    builder: (context, snapshot) {
                      return DashBoardHeaderWidget(
                        profilelogo: profilePicture,
                        tapCal: () {
                          setState(() {
                            Get.to(() => RenterProfileHomePage());
                          });
                        },
                      );
                    }),
                const SizedBox(height: 0),
                SearchBarWidget(
                  title: 'Search Vehicle',
                  hintText: 'Enter a vehicle to search',
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text('For You',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        VehicleSelectFilter(
                          vehicleImg: TImages.car,
                          title: 'Car',
                          tapCal: () {
                            Get.to(() => ProductListing(vehicleType: 'car'));
                          },
                        ),
                        const SizedBox(width: 5),
                        VehicleSelectFilter(
                          vehicleImg: TImages.bicycle,
                          title: 'Bicycle',
                          tapCal: () {
                            Get.to(
                              ProductListing(vehicleType: 'bicycle'),
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                        VehicleSelectFilter(
                          vehicleImg: TImages.motorBike,
                          title: 'Motor Bike',
                          tapCal: () {
                            Get.to(
                              ProductListing(vehicleType: 'motor bike'),
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                        VehicleSelectFilter(
                          vehicleImg: TImages.rickshaw,
                          title: 'Rickshaw',
                          tapCal: () {
                            Get.to(
                              ProductListing(vehicleType: 'rickshaw'),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ImageCarousel(
                  imageList: [
                    {"id": '1', "image_path": TImages.mahendiraThar},
                    {"id": '2', "image_path": TImages.bikeHonda},
                    {"id": '3', "image_path": TImages.rover},
                    {"id": '4', "image_path": TImages.autoBajaj},
                  ],
                  carouselController: carouselController,
                ),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'Best Selling',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        vehicleList(),
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
        unselectedItemColor: TColors.darkGrey,
        selectedItemColor: TColors.primary,
        backgroundColor: TColors.secondary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.message),
                if (hasUnreadMessages) // Display indicator if there are unread messages
                  Positioned(
                    bottom: 12,
                    right: 0,
                    child: Container(
                      height: 12,
                      width: 12,
                      // padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Icon(Icons.message),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined), // Chat icon

            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox),
            label: 'Bookings',
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (Route<dynamic> route) => false,
              );
              break;
            case 1:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RenterChatHomePage()));
              break;
            case 2:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProductListing()));
              break;
            case 3:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyBookings()));
              break;
            case 4:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RenterProfileHomePage()));
              break;
          }
        },
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<Map<String, String>> imageList;
  final CarouselController carouselController;

  const ImageCarousel({
    Key? key,
    required this.imageList,
    required this.carouselController,
  }) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              // Your onTap logic here
            },
            child: CarouselSlider(
              items: widget.imageList.map((item) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    item['image_path']!,
                    width: double.infinity,
                  ),
                );
              }).toList(),
              carouselController: widget.carouselController,
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.1,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () =>
                      widget.carouselController.animateToPage(entry.key),
                  child: Container(
                    width: currentIndex == entry.key ? 17 : 7,
                    height: 5.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentIndex == entry.key
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
