// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/rented_vehicle_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/lender_review/lender_review_page.dart';
import 'package:xplorit/features/product/features_widget.dart';
import 'package:xplorit/features/product/price_tag_widget.dart';
import 'package:xplorit/features/product/rent_request.dart';
import 'package:xplorit/features/product/vehicle_details_naviagtion.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({
    required this.vehicleId,
    Key? key,
  }) : super(key: key);

  final String vehicleId;

  @override
  State<VehicleDetails> createState() => _VehicleDetails();
}

class _VehicleDetails extends State<VehicleDetails> {
  final controller = Get.put(VehicleController());
  final renterController = Get.put(RenterController());
  final bookingController = Get.put(BookingController());
  final garageController = Get.put(GarageController());
  final rentedVehicleController = Get.put(RentedVehicleController());
  bool isRequestSent = false;
  bool isRentedAVehicle = false;
  String renterId = '';
  String garageName = '';

  // @override
  // void initState() {
  //   super.initState();
  //   controller.fetchVehicleData();
  // }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchGarageData();
    // await fetchBookingData();
    await fetchRenterId();
    await _checkRequest();
  }

  Future<void> fetchGarageData() async {}

  // Future<void> fetchBookingData() async {
  //   await bookingController.fetchBookingData();
  // }

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
        for (RentedVehicleModel rentedVehicle
            in rentedVehicleController.rentedvehiclesData) {
          if (rentedVehicle.renterId == renterId) {
            isRentedAVehicle = true;
          }
        }
      } catch (e) {
        try {
          var currentRenter = renterController.rentersData.firstWhere(
            (renter) => renter.contactNumber == userPhoneNumber,
            // orElse: () => RenterModel,
          );

          renterId = currentRenter != null && currentRenter.renterId.isNotEmpty
              ? currentRenter.renterId
              : '';

          for (RentedVehicleModel rentedVehicle
              in rentedVehicleController.rentedvehiclesData) {
            if (rentedVehicle.renterId == renterId) {
              isRentedAVehicle = true;
            }
          }
        } catch (e) {
          renterId = '';
        }
      }
    }
  }

  Future<void> _checkRequest() async {
    for (BookingModel booking in bookingController.bookingsData) {
      if (renterId == booking.renterId &&
          widget.vehicleId == booking.vehicleId) {
        setState(() {
          isRequestSent = true;
        });
      }
    }
  }

  double longitude = 0.0;
  double latitude = 0.0;
  String vehicleCity = 'unknown';
  String locationName = '';
  double distance = 0.0;
  var imageUrl = '';

  Future<void> _fetchAddress(String location) async {
    try {
      List<String> coordinates = location.split(',');
      setState(() {
        longitude = double.parse(coordinates[0]);
        latitude = double.parse(coordinates[1]);
      });

      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   latitude,
      //   longitude,
      // );

      // if (placemarks.isNotEmpty) {
      //   Placemark placemark = placemarks.first;
      //   vehicleCity = placemark.subAdministrativeArea ?? '';
      // }
    } catch (e) {
      print('Error fetching address: $e');

      vehicleCity = 'Error fetching address';
    }
    // return vehicleCity;
  }

  Future<List<Widget>> _buildVehicleWidgets(
      List<Map<String, String>> imageList) async {
    List<Widget> vehicleWidgets = [];

    List<Map<String, String>> vehicleImageList = [];

    try {
      for (VehicleModel vehicle in controller.vehiclesData) {
        if (vehicle.vehicleId == widget.vehicleId) {
          distance = await calculateDistance(vehicle.pickupLocation);
          locationName = await getLocationName(vehicle.pickupLocation);

          if (vehicle.vehicleImage.isNotEmpty) {
            try {
              imageList = [];
              for (int i = 0; i < vehicle.vehicleImage.length; i++) {
                vehicleImageList.add(
                    {"id": '${i + 1}', "image_path": vehicle.vehicleImage[i]});
              }
              imageList = vehicleImageList;
            } catch (e) {
              Get.snackbar('title', e.toString());
            }
          } else {
            imageList = [
              {"id": '1', "image_path": TImages.mahendiraThar},
            ];
          }

          for (GarageModel garage in garageController.garagesData) {
            if (garage.garageId == vehicle.garageId) {
              garageName = garage.userName;
            }
          }
          vehicleWidgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Details',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vehicle.model,
                      style: Theme.of(context).textTheme.headlineMedium?.apply(
                            color: TColors.greyDark,
                          ),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Get.to(() => LenderReviewPage(
                                  editMode: false,
                                  productId: vehicle.vehicleId,
                                ));
                          },
                          icon: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          label: Text(
                            '${vehicle.rating.toString()} (${vehicle.noOfRating} Reviews)',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                ImageCarousel(imageList: imageList),
                const SizedBox(height: 10),
                Text(
                  'Garage',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: TColors.darkGrey),
                ),
                const SizedBox(height: 5),
                FeaturesWidget(
                  title1: garageName,
                  title2: '',
                ),
                const SizedBox(height: 10),
                Text(
                  'Car Features',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: TColors.darkGrey),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    FeaturesWidget(
                      title1: 'Model',
                      title2: vehicle.model,
                    ),
                    Visibility(
                      visible: vehicle.vehicleType != 'bicycle',
                      child: FeaturesWidget(
                        title1: 'Seating Capacity',
                        title2: vehicle.seatingCapacity.toString(),
                      ),
                    ),
                    Visibility(
                      visible: vehicle.vehicleType != 'bicycle',
                      child: FeaturesWidget(
                        title1: 'Mileage',
                        title2: vehicle.mileage,
                      ),
                    ),
                    Visibility(
                      visible: vehicle.vehicleType != 'bicycle' &&
                          vehicle.vehicleType != 'motor bike',
                      child: FeaturesWidget(
                        title1: 'Fuel Type',
                        title2: vehicle.fuelType,
                      ),
                    ),
                    Visibility(
                      visible: vehicle.vehicleType != 'bicycle' &&
                          vehicle.vehicleType != 'rickshaw',
                      child: FeaturesWidget(
                        title1: 'Transmission',
                        title2: vehicle.transmission,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Rental Rates',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: TColors.darkGrey),
                ),
                const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                PriceTag(
                    timeTitle: vehicle.rentalRateType,
                    price: vehicle.rentalRates.toString()),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     PriceTag(
                //         timeTitle: 'Per Day',
                //         price: vehicle.pricePerday.toString()),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     PriceTag(
                //         timeTitle: 'Per Week',
                //         price: vehicle.pricePerWeek.toString()),
                //   ],
                // ),
                const SizedBox(height: 10),
                Text(
                  'Extra Features',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: TColors.darkGrey),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    for (String rule in vehicle.extraFeatures)
                      FeaturesWidget(title1: rule),
                    const SizedBox(height: 5),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'Pickup Location',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: TColors.darkGrey),
                ),
                const SizedBox(height: 15),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      height: 350,
                      child: GoogleMap(
                        initialCameraPosition: initialCameraPosition,
                        markers: markers,
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          googleMapController = controller;
                        },
                      ),
                    ),
                    Positioned(
                      top: 125,
                      left: 70,
                      right: 70,
                      child: Center(
                        child: ElevatedBTN(
                            onTapCall: () async => {
                                  await _fetchAddress(vehicle.pickupLocation),
                                  Get.to(
                                      // MyMapPage()
                                      NavigationToShop(
                                    latitude: latitude,
                                    longitude: longitude,
                                    // locationName: locationName,
                                    // distance: distance,
                                  ))
                                },
                            titleBtn: "Tap to See Direction",
                            btnColor: TColors.blueLight,
                            textColor: TColors.black),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: TColors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(locationName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.normal)),
                                Text(
                                    '${distance.toStringAsFixed(2)} km away from location',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Rules and Requirements',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: TColors.darkGrey),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    for (String rule in vehicle.rules)
                      FeaturesWidget(title1: rule),
                    const SizedBox(height: 5),
                  ],
                ),
                const SizedBox(height: 25),
                // ElevatedBTN(
                //   titleBtn:
                //       !isRequestSent ? 'Rent Now' : 'Request already sent',
                //   onTapCall: !isRequestSent
                //       ? () {
                //           Get.to(() =>
                //               RequestForRent(vehicleId: vehicle.vehicleId));
                //         }
                //       : () => {},
                // ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: !isRentedAVehicle && !isRequestSent,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                TColors.primary, // Adjust colors as needed
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestForRent(
                                    vehicleId: vehicle.vehicleId),
                              ),
                            );
                            // Get.to(() =>
                            //     RequestForRent(vehicleId: vehicle.vehicleId));
                          },
                          child: Text('Rent Now'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: isRentedAVehicle,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                TColors.accent, // Adjust colors as needed
                          ),
                          onPressed: () {},
                          child: Text(
                            'You already reneted a vehicle.',
                            style: TextStyle(color: TColors.primary),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: !isRentedAVehicle && isRequestSent,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                TColors.accent, // Adjust colors as needed
                          ),
                          onPressed: () {},
                          child: Text(
                            'Request Already sent ',
                            style: TextStyle(color: TColors.primary),
                          ),
                        ),
                      ),
                    ),
                    // IgnorePointer(
                    //   ignoring: isRequestSent,
                    //   child:
                    //   if(!isRequest)
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: isRequestSent || isRentedAVehicle
                    //         ? Colors.grey
                    //         : TColors.primary, // Adjust colors as needed
                    //   ),
                    //   onPressed: () {
                    //     !isRequestSent && !isRentedAVehicle
                    //         ? () {
                    //             Get.to(() => RequestForRent(
                    //                 vehicleId: vehicle.vehicleId));
                    //           }
                    //         : null;
                    //   },
                    //   child: Text(
                    //     isRentedAVehicle
                    //         ? 'You are already rented a vehicle'
                    //         : (!isRequestSent
                    //             ? 'Rent Now'
                    //             : 'Request already sent'),
                    //     style: TextStyle(
                    //       color: isRequestSent || isRentedAVehicle
                    //           ? TColors.primary
                    //           : TColors.white, // Adjust text color
                    //     ),
                    //   ),
                    // ),

                    // ElevatedButton(
                    //   onPressed: !isRequestSent
                    //       ? () {
                    //           Get.to(() => RequestForRent(
                    //               vehicleId: vehicle.vehicleId));
                    //         }
                    //       : null,
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: isRequestSent
                    //         ? Colors.grey
                    //         : TColors.primary, // Adjust colors as needed
                    //   ),
                    //   child: Text(
                    //     !isRequestSent
                    //         ? 'Rent Now'
                    //         : 'Request already sent',
                    //     style: TextStyle(
                    //       color: isRequestSent
                    //           ? Colors.black
                    //           : Colors.white, // Adjust text color
                    //     ),
                    //   ),
                    // ),
                    // ),
                    // ),
                  ],
                )
              ],
            ),
          );
        }
      }
    } catch (e) {
      Get.snackbar('Ooop!', e.toString());
    }
    return vehicleWidgets;
  }

  Widget fetchVehicleDeatils(List<Map<String, String>> imageList) {
    return FutureBuilder<List<Widget>>(
      future: _buildVehicleWidgets(imageList),
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

  Future<String> getLocationName(String location) async {
    try {
      List<String> coordinates = location.split(',');
      double longitude = double.parse(coordinates[0]);
      double latitude = double.parse(coordinates[1]);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        return '${placemark.name}, ${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}';
      } else {
        return 'null';
      }
    } catch (e) {
      print('Error fetching location: $e');
      return '';
    }
  }

  List<Map<String, String>> imageList = [
    {"id": '1', "image_path": TImages.mahendiraThar},
    {"id": '2', "image_path": TImages.mahendiraThar2},
    {"id": '3', "image_path": TImages.mahendiraThar3},
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(31.4615, 73.1482), zoom: 14);

  Set<Marker> markers = {};
  // Widget vehicleData() {
  //   return
  // }

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
                BackButtonWidget(),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fetchVehicleDeatils(imageList),
                    DividerWidget(),
                  ],
                ),
              ],
            ),
          ), //main Column
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<Map<String, String>> imageList;
  final CarouselController carouselController = CarouselController();

  ImageCarousel({required this.imageList, Key? key}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                // Add any debug logic here if needed
              },
              child: CarouselSlider(
                items: widget.imageList.map((item) {
                  return item['image_path']!.startsWith('http')
                      ? Image.network(
                          item['image_path']!,
                          // height: 200,
                          // width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person, size: 50),
                                ],
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          item['image_path']!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person, size: 50),
                                ],
                              ),
                            );
                          },
                        );
                }).toList(),
                carouselController: widget.carouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 2,
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
              bottom: 5,
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
                            ? TColors.primary
                            : TColors.white,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
