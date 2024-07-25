// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/features/Renter_chat/renter_chat_home_page.dart';
import 'package:xplorit/features/booking_status/my_bookings.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/dashbord/renter_profile/renter_profile_home.dart';
import 'package:xplorit/features/dashbord/search_bar_widget.dart';
import 'package:xplorit/features/dashbord/vehicle_label_widget.dart';
import 'package:xplorit/features/product/vehicle_details.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class ProductListing extends StatefulWidget {
  ProductListing({
    super.key,
    this.isFiltered = false,
    this.byCity = false,
    this.vehicleTypeList,
    this.vehicleType = '',
    this.model = '',
    this.priceRangeLow = 0,
    this.priceRangeHigh = 0,
    this.distance = 0.0,
    this.city = '',
  });

  List<String>? vehicleTypeList;
  String vehicleType;
  int priceRangeLow;
  int priceRangeHigh;
  double distance;
  String model;
  String city;
  bool isFiltered;
  bool byCity;

  @override
  State<ProductListing> createState() => _ProductListing();
}

class _ProductListing extends State<ProductListing> {
  int bottomNavBarCurrentIndex = 2;
  final controller = Get.put(VehicleController());
  int count = 0;
  String vehicleCity = '';
  String defaultVehicleImage = TImages.car;
  String titleWithCity = '';

  String capitalize(String input) {
    if (input.isEmpty) {
      return 'Vehicles'; // Return empty string if input is empty
    }
    return '${input[0].toUpperCase()}${input.substring(1)}s';
  }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];
    for (VehicleModel vehicle in controller.vehiclesData) {
      double distance = await calculateDistance(vehicle.pickupLocation);
      if (!widget.byCity && distance < widget.distance) {
        ++count;
      }
    }

    if (count == 0) {
      widget.distance = 15;
    }

    if (widget.city == 'Selected City') {
      widget.city = '';
    }
    for (VehicleModel vehicle in controller.vehiclesData) {
      if (vehicle.isVehicleActive) {
        double distance = await calculateDistance(vehicle.pickupLocation);
        bool matchesFilter = true;

        if (widget.isFiltered) {
          if (widget.vehicleTypeList != null &&
              !widget.vehicleTypeList!.contains(vehicle.vehicleType)) {
            matchesFilter = false;
          }
          if (widget.priceRangeLow > 0 &&
              widget.priceRangeHigh > 0 &&
              (vehicle.rentalRates < widget.priceRangeLow ||
                  vehicle.rentalRates > widget.priceRangeHigh)) {
            matchesFilter = false;
          }
          if (widget.byCity && widget.city.isNotEmpty) {
            String vehicleCity = await _fetchAddress(vehicle.pickupLocation);
            if (vehicleCity != widget.city) {
              matchesFilter = false;
            }
          }
          if (widget.distance > 0 && distance > widget.distance) {
            matchesFilter = false;
          }
        } else {
          if (widget.vehicleType.isNotEmpty &&
              vehicle.vehicleType != widget.vehicleType) {
            matchesFilter = false;
          }
          if (widget.model.isNotEmpty &&
              !vehicle.model
                  .toLowerCase()
                  .contains(widget.model.toLowerCase())) {
            matchesFilter = false;
          }
          if (widget.distance > 0 && distance > 15) {
            matchesFilter = false;
          }
        }

        if (matchesFilter) {
          defaultVehicleImage = vehicle.vehicleImage.isNotEmpty
              ? vehicle.vehicleImage[0]
              : TImages.car;
          vehicleWidgets.add(
            Column(
              children: [
                VehicleLabelWidget(
                  vehicleTitle: vehicle.model,
                  vehicleImage: defaultVehicleImage,
                  rating: vehicle.rating,
                  noOfRating: vehicle.noOfRating,
                  distance: '${distance.toStringAsFixed(2)}km',
                  price: '${vehicle.rentalRates} PKR ${vehicle.rentalRateType}',
                  onTapCall: () {
                    Get.to(VehicleDetails(vehicleId: vehicle.vehicleId));
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        }
      }
    }
    if (vehicleWidgets.isEmpty) {
      vehicleWidgets.add(
        Center(
          child: Text('No vehicles available'),
        ),
      );
    }

    return vehicleWidgets;
  }

  Widget vehicleList() {
    return FutureBuilder<List<Widget>>(
      future: _buildVehicleWidgets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data!,
          );
        }
      },
    );
  }

  Future<Map<String, double>> getLocationCoordinates(
      String locationName) async {
    List<Location> locations = [];

    try {
      locations = await locationFromAddress(locationName);
    } catch (e) {
      print('Error fetching location coordinates: $e');
    }

    double latitude = locations.isNotEmpty ? locations.first.latitude : 0.0;
    double longitude = locations.isNotEmpty ? locations.first.longitude : 0.0;

    return {'latitude': latitude, 'longitude': longitude};
  }

  Future<String> _fetchAddress(String location) async {
    try {
      List<String> coordinates = location.split(',');
      double longitude = double.parse(coordinates[0]);
      double latitude = double.parse(coordinates[1]);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        vehicleCity = placemark.subAdministrativeArea ?? '';
      }
    } catch (e) {
      print('Error fetching address: $e');

      vehicleCity = 'Error fetching address';
    }
    return vehicleCity;
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

  Future<String> calculateTravelTime(String destinationLocation) async {
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Retrieve destination location coordinates from the database
    Map<String, double> destinationCoordinates =
        await getLocationCoordinates(destinationLocation);

    double destinationLatitude = destinationCoordinates['latitude'] ?? 0.0;
    double destinationLongitude = destinationCoordinates['longitude'] ?? 0.0;

    // Make HTTP request to Google Maps Directions API
    String apiKey = 'AIzaSyBOxY_BbJdnSqw8MFTQiM89XJhZCvYUjKs';

    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${currentPosition.latitude},${currentPosition.longitude}&'
        'destination=$destinationLatitude,$destinationLongitude&'
        'key=$apiKey';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse JSON response
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        // Extract travel time from response
        String travelTime = data['routes'][0]['legs'][0]['duration']['text'];
        return travelTime;
      } else {
        throw Exception('Failed to fetch directions: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.isFiltered && widget.byCity) {
      titleWithCity = ' in ${widget.city}';
    }
    // Show the snackbar here instead
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get.snackbar('Type', widget.vehicleType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button from popping the current route
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Positioned(
              //   top: 10,
              //   right: TSizes.defaultSpace,
              //   child: CircleAvatar(
              //     radius: 35,
              //     backgroundImage: AssetImage(TImages.profile),
              //   ),
              // ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BackButtonWidget(),
                      TextButton.icon(
                        onPressed: () {
                          Get.offAll(() => Dashboard());
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 15,
                          color: Colors
                              .black, // Use btnColor if provided, otherwise use default color
                        ),
                        label: Text(
                          'Back',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  color: Colors
                                      .black), // Use btnColor if provided, otherwise use default color
                        ),
                      ),
                      SearchBarWidget(
                        title:
                            'Available ${capitalize(widget.vehicleType)}$titleWithCity',
                        hintText: 'Nearby Vehicles',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height -
                            200, // Adjust height as needed
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              vehicleList(),
                              DividerWidget(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNavBarCurrentIndex,
          unselectedItemColor: TColors.darkGrey,
          selectedItemColor: TColors.primary,
          backgroundColor: TColors.secondary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
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
      ),
    );
  }
}
