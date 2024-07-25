// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/features/dashbord/search_bar_widget.dart';
import 'package:xplorit/features/dashbord/vehicle_label_widget.dart';
import 'package:xplorit/features/product/vehicle_details.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class FilteredProductListing extends StatefulWidget {
  FilteredProductListing({
    super.key,
    this.byCity = false,
    this.vehicleTypeList,
    this.priceRangeLow = 0,
    this.priceRangeHigh = 0,
    this.distance = 0.0,
    this.city = '',
  });

  List<String>? vehicleTypeList;
  int priceRangeLow;
  int priceRangeHigh;
  double distance;
  String city;
  bool byCity;

  @override
  State<FilteredProductListing> createState() => _FilteredProductListing();
}

class _FilteredProductListing extends State<FilteredProductListing> {
  final controller = Get.put(VehicleController());
  int count = 0;
  String vehicleCity = '';
  String defaultVehicleImage = '';
  String titleWithCity = '';

  String capitalize(String input) {
    if (input.isEmpty) {
      return 'Vehicles'; // Return empty string if input is empty
    }
    return '${input[0].toUpperCase()}${input.substring(1)}s';
  }

  // Future<List<Widget>> _buildVehicleWidgets() async {
  //   List<Widget> vehicleWidgets = [];
  //   for (VehicleModel vehicle in controller.vehiclesData) {
  //     double distance = await calculateDistance(vehicle.pickupLocation);
  //     if (!widget.byCity && distance < widget.distance) {
  //       ++count;
  //     }
  //   }

  //   if (count == 0) {
  //     widget.distance = 15;
  //   }

  //   if (widget.city == 'Selected City') {
  //     widget.city = '';
  //   }
  //   for (VehicleModel vehicle in controller.vehiclesData) {
  //     double distance = await calculateDistance(vehicle.pickupLocation);
  //     bool matchesFilter = true;

  //     Get.snackbar(widget.vehicleTypeList!.join(','), widget.byCity.toString() );

  //     if (widget.vehicleTypeList != null &&
  //         !widget.vehicleTypeList!.contains(vehicle.vehicleType)) {
  //       matchesFilter = false;
  //     }
  //     if (widget.priceRangeLow > 0 &&
  //         widget.priceRangeHigh > 0 &&
  //         (vehicle.rentalRates < widget.priceRangeLow ||
  //             vehicle.rentalRates > widget.priceRangeHigh)) {
  //       matchesFilter = false;
  //     }
  //     if (widget.byCity && widget.city.isNotEmpty) {
  //       String vehicleCity = await _fetchAddress(vehicle.pickupLocation);
  //       if (vehicleCity != widget.city) {
  //         matchesFilter = false;
  //       }
  //     }
  //     if (widget.distance > 0 && distance > widget.distance) {
  //       matchesFilter = false;
  //     }

  //     if (matchesFilter) {
  //       defaultVehicleImage =
  //           vehicle.vehicleImage.isNotEmpty ? vehicle.vehicleImage[0] : 'http';
  //       vehicleWidgets.add(
  //         Column(
  //           children: [
  //             VehicleLabelWidget(
  //               vehicleTitle: vehicle.model,
  //               vehicleImage: defaultVehicleImage,
  //               rating: vehicle.rating.toString(),
  //               distance: '${distance.toStringAsFixed(2)}km',
  //               price: '${vehicle.rentalRates} PKR ${vehicle.rentalRateType}',
  //               onTapCall: () {
  //                 Get.to(VehicleDetails(vehicleId: vehicle.vehicleId));
  //               },
  //             ),
  //             SizedBox(height: 20),
  //           ],
  //         ),
  //       );
  //     }
  //   }
  // return vehicleWidgets;
  // }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];

    bool foundCloserVehicle = false;
    for (VehicleModel vehicle in controller.vehiclesData) {
      if (vehicle.isVehicleActive) {
        // Check if the vehicle type is in the list of vehicle types to include
        if (!widget.vehicleTypeList!.contains(vehicle.vehicleType)) {
          continue; // Skip this vehicle if its type is not in the list
        }

        double distance = await calculateDistance(vehicle.pickupLocation);

        if (!widget.byCity && distance < widget.distance) {
          foundCloserVehicle = true;
          break; // No need to continue if we found at least one closer vehicle
        }
      }
    }

    // If no vehicles are closer than widget.distance, set widget.distance to 15
    if (!foundCloserVehicle) {
      widget.distance = 15;
    }
    for (VehicleModel vehicle in controller.vehiclesData) {
      if (vehicle.isVehicleActive) {
        if (!widget.vehicleTypeList!.contains(vehicle.vehicleType)) {
          continue;
        }
        double distance = await calculateDistance(vehicle.pickupLocation);
        bool matchesFilter = true;

        if (count == 0) {
          widget.distance = 15;
        }

        if (widget.byCity && widget.city.isNotEmpty) {
          String vehicleCity = await _fetchAddress(vehicle.pickupLocation);
          if (vehicleCity != widget.city) {
            matchesFilter = false;
          }
        }

        if (!widget.byCity && distance > widget.distance) {
          matchesFilter = false;
        }

        // Add vehicle to widgets if it matches the filter
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

    if (widget.byCity) {
      titleWithCity = ' in ${widget.city}';
    }
    // Show the snackbar here instead
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get.snackbar('Type', widget.vehicleType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    BackButtonWidget(),
                    SearchBarWidget(
                      title:
                          'Available ${capitalize(widget.vehicleTypeList!.join(', '))}$titleWithCity',
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
    );
  }
}
