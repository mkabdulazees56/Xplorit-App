// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/cancel_booking_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/cancelled_booking_model.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/rented_vehicle_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/lent/AddVehicle/select_vehicle_type.dart';
import 'package:xplorit/features/lent/garage/garage_vehicle_active.dart';
import 'package:xplorit/features/lent/garage/garage_vehicle_card_notrented_widget.dart';
import 'package:xplorit/features/lent/garage/garage_vehicle_details_card_widget.dart';
import 'package:xplorit/features/lent/garage/garage_vehicle_rented.dart';
import 'package:xplorit/features/lent/garage/garage_vehicles_notactive.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class MyGaragePage extends StatefulWidget {
  const MyGaragePage({Key? key}) : super(key: key);

  @override
  State<MyGaragePage> createState() => _MyGaragePageState();
}

class _MyGaragePageState extends State<MyGaragePage> {
  String garageId = '';
  String garageLocation = '';
  String garageName = '';
  String defaultVehicleImage = TImages.car;
  String renterImage = '';
  String renterName = '';
  String renterContactNumber = '';
  String renterId = '';
  int bottomNavBarCurrentIndex = 0;
  final String locationName = "unknown";
  List<RentedVehicleModel> rentedVehicles = [];

  final garageController = Get.put(GarageController());
  final renterController = Get.put(RenterController());
  final vehicleController = Get.put(VehicleController());
  final bookingController = Get.put(BookingController());
  final cancelledBookingController = Get.put(CancelledBookingController());
  final rentedVehicleController = Get.put(RentedVehicleController());
  List<BookingModel> bookings = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await fetchGarageId();
    await fetchRenterData();
    await fetchRentedVehicle();
    await fetchGarageData();
    await fetchVehicleData();
  }

  Future<void> fetchVehicleData() async {
    try {
      await vehicleController.fetchVehicleData();
    } catch (e) {}
  }

  Future<void> fetchGarageData() async {
    await garageController.fetchGarageData();
  }

  Future<void> fetchRenterData() async {
    await renterController.fetchRenterData();
  }

  Future<void> fetchRentedVehicle() async {
    try {
      for (RentedVehicleModel rentedVehicle
          in rentedVehicleController.rentedvehiclesData) {
        if (rentedVehicle.garageId == garageId) {
          rentedVehicles.add(rentedVehicle);
        }
      }
    } catch (error) {
      print('Error fetching rented vehicles: $error');
    }
  }

  Future<void> fetchGarageId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userPhoneNumber = user.phoneNumber ?? '';

      try {
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
        for (GarageModel garage in garageController.garagesData) {
          if (garageId == garage.garageId) {
            try {
              setState(() {
                garageName = garage.userName;
                garageLocation = garage.address;
              });
            } catch (r) {
              garageName = garage.userName;
              garageLocation = garage.address;
            }
          }
        }
      } catch (e) {
        var matchingGarage = garageController.garagesData.firstWhere(
          (garage) => garage.contactNumber == userPhoneNumber,
        );

        garageId = matchingGarage != null && matchingGarage.garageId.isNotEmpty
            ? matchingGarage.garageId
            : '';
        for (GarageModel garage in garageController.garagesData) {
          if (garageId == garage.garageId) {
            try {
              setState(() {
                garageName = garage.userName;
                garageLocation = garage.address;
              });
            } catch (r) {
              garageName = garage.userName;
              garageLocation = garage.address;
            }
          }
        }
      }
    }
  }

  // showConfirmation(
  //     context, String vehicleId, String vehicleModel, double vehicleRating) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible:
  //           false, // Prevents dismissing by tapping outside the dialog

  //       builder: (context) => AlertDialog(
  //             title: const Text(
  //               'Are you sure\nyou want to remove this vehicle.\nThe bookings in this vehilce will also be removed.',
  //               textAlign: TextAlign.center,
  //             ),
  //             actions: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   SizedBox(
  //                       width: 120,
  //                       child: ElevatedBTN(
  //                           titleBtn: 'Yes',
  //                           onTapCall: () {
  //                             Navigator.of(context).pop(false);
  //                             for (var booking in bookings) {
  //                               bookingController
  //                                   .removeBookingData(booking.bookingId);
  //                               final cancelBooking = CancelledBookingModel(
  //                                 cancelledBookingId: 'b1',
  //                                 bookingId: booking.bookingId,
  //                                 renterId: booking.renterId,
  //                                 vehicleId: booking.vehicleId,
  //                                 startDate: booking.startDate,
  //                                 endDate: booking.endDate,
  //                                 canelledBy: 'Lender',
  //                                 garageId: garageId,
  //                                 garageName: garageName,
  //                                 garageLocation: garageLocation,
  //                                 vehicleImage: defaultVehicleImage,
  //                                 vehicleModel: vehicleModel,
  //                                 vehicleRating: vehicleRating,
  //                               );
  //                               cancelledBookingController
  //                                   .addCancelledBookingData(cancelBooking);
  //                             }
  //                             // vehicleController.removeVehicleData(vehicleId);
  //                           },
  //                           btnColor: Colors.red)),
  //                   SizedBox(
  //                     width: 120,
  //                     child: OutlinedButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop(false);
  //                       },
  //                       child: Text(
  //                         'No',
  //                         style: Theme.of(context).textTheme.headlineSmall,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ));
  // }

  showConfirmation(
      context, String vehicleId, String vehicleModel, double vehicleRating) {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing by tapping outside the dialog
      builder: (context) => AlertDialog(
        title: const Text(
          'Are you sure\nyou want to remove this vehicle.\nThe bookings in this vehicle will also be removed.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 120,
                child: ElevatedBTN(
                  titleBtn: 'Yes',
                  onTapCall: () {
                    Navigator.of(context).pop(false);
                    _cancelBookingsAndRemoveVehicle(
                        vehicleId, vehicleModel, vehicleRating);
                  },
                  btnColor: Colors.red,
                ),
              ),
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'No',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _cancelBookingsAndRemoveVehicle(
      String vehicleId, String vehicleModel, double vehicleRating) {
    List<BookingModel> bookingsToCancel = [];

    // Find bookings associated with the vehicle
    for (BookingModel booking in bookingController.bookingsData) {
      if (booking.vehicleId == vehicleId) {
        bookingsToCancel.add(booking);
      }
    }

    // Process each booking for cancellation and remove it
    for (BookingModel booking in bookingsToCancel) {
      bookingController.removeBookingData(booking.bookingId);
      final cancelBooking = CancelledBookingModel(
        cancelledBookingId: 'b1',
        bookingId: booking.bookingId,
        renterId: booking.renterId,
        vehicleId: booking.vehicleId,
        startDate: booking.startDate,
        endDate: booking.endDate,
        canelledBy: 'Lender',
        garageId: garageId,
        garageName: garageName,
        garageLocation: garageLocation,
        vehicleImage: defaultVehicleImage,
        vehicleModel: vehicleModel,
        vehicleRating: vehicleRating,
      );
      cancelledBookingController.addCancelledBookingData(cancelBooking);
    }

    vehicleController.removeVehicleData(vehicleId);
  }
  // Future<List<Widget>> _buildVehicleWidgets() async {
  //   List<Widget> vehicleWidgets = [];
  //   Widget vehicleWidget;

  //   for (VehicleModel vehicle in vehicleController.vehiclesData) {
  //     if (garageId == vehicle.garageId) {
  //       String defaultImage = '';
  //       try {
  //         if (vehicle.vehicleImage.isNotEmpty &&
  //             vehicle.vehicleImage[0].isNotEmpty) {
  //           defaultImage = vehicle.vehicleImage[0];
  //           defaultVehicleImage = vehicle.vehicleImage[0];
  //         } else {
  //           defaultImage = 'TImage.person';
  //           defaultVehicleImage = 'TImage.person';
  //         }
  //       } catch (e) {
  //         defaultVehicleImage = 'TImage.person';
  //         defaultImage = 'TImage.person';
  //       }

  //       for (var rentedVehicle in rentedVehicles) {
  //         if (vehicle.vehicleId == rentedVehicle.vehicleId) {
  //           for (RenterModel renter in renterController.rentersData) {
  //             if (renter.renterId == rentedVehicle.renterId) {
  //               try {
  //                 renterImage = renter.profilePicture != null &&
  //                         renter.profilePicture.isNotEmpty
  //                     ? renter.profilePicture
  //                     : TImages.profile;
  //               } catch (e) {
  //                 renterImage = TImages.profile;
  //               }
  //               renterId = renter.renterId;
  //               renterName = renter.userName;
  //             }
  //           }
  //           vehicleWidget = GestureDetector(
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => MyGaragePageRented(
  //                           renterImage: renterImage,
  //                           renterName: renterName,
  //                           renterId: renterId,
  //                           vehicleId: vehicle.vehicleId,
  //                           model: vehicle.model,
  //                           defaultVehicleImage: defaultImage,
  //                           isVehicleActive: vehicle.isVehicleActive,
  //                           rating: vehicle.rating.toString(),
  //                         )),
  //               );
  //             },
  //             child: GarageVehicleDetailsCardWidgets(
  //               renderImage: renterImage,
  //               renterName: renterName,
  //               vehicleImg: defaultVehicleImage,
  //               vehicleName: vehicle.model,
  //               ratingText: vehicle.rating.toString(),
  //               statusText: "Rented",
  //               statusFgColor: TColors.black,
  //               statusBgColor: Colors.green,
  //             ),
  //           );
  //           vehicleWidgets.add(vehicleWidget);
  //           vehicleWidgets.add(SizedBox(height: 15));
  //         } else {
  //           vehicleWidget = GestureDetector(
  //             onTap: () {
  //               if (vehicle.isVehicleActive) {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => MyGaragePageActive(
  //                       vehicleId: vehicle.vehicleId,
  //                       model: vehicle.model,
  //                       defaultVehicleImage: defaultImage,
  //                       isVehicleActive: vehicle.isVehicleActive,
  //                       rating: vehicle.rating.toString(),
  //                     ),
  //                   ),
  //                 );
  //               } else {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => MyGaragePageNotActive(
  //                       vehicleId: vehicle.vehicleId,
  //                       model: vehicle.model,
  //                       defaultVehicleImage: defaultImage,
  //                       isVehicleActive: vehicle.isVehicleActive,
  //                       rating: vehicle.rating.toString(),
  //                     ),
  //                   ),
  //                 );
  //               }
  //             },
  //             child: GarageVehicleDetailsNotCardWidgets(
  //               vehicleImg: defaultVehicleImage,
  //               vehicleName: vehicle.model,
  //               ratingText: vehicle.rating.toString(),
  //               statusText: vehicle.isVehicleActive ? "Active" : "Non Active",
  //               statusFgColor: TColors.black,
  //               statusBgColor: Colors.blue.shade100,
  //             ),
  //           );
  //           vehicleWidgets.add(vehicleWidget);
  //           vehicleWidgets.add(SizedBox(height: 15));
  //         }
  //       }
  //       // Add spacing between vehicles
  //     }
  //   }

  //   if (vehicleWidgets.isEmpty) {
  //     vehicleWidgets.add(
  //       Center(
  //         child: Text(''),
  //       ),
  //     );
  //   }

  //   return [
  //     Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: vehicleWidgets,
  //     ),
  //   ];
  // }

  // String generateOTP() {
  //   var rng = Random();
  //   return (100000 + rng.nextInt(900000)).toString();
  // }

  // Future<void> saveOTPToFirestore(
  //     String otp, String renterId, String lenderId) async {
  //   await FirebaseFirestore.instance.collection('otps').doc(renterId).set({
  //     'otp': otp,
  //     'renterId': renterId,
  //     'lenderId': lenderId,
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }

  // Future<void> generateAndSaveOTP(String renterId, String lenderId) async {
  //   String otp = generateOTP();
  //   await saveOTPToFirestore(otp, renterId, lenderId);
  // }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];
    Widget vehicleWidget;

    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      if (garageId == vehicle.garageId) {
        String defaultImage = '';
        try {
          if (vehicle.vehicleImage.isNotEmpty &&
              vehicle.vehicleImage[0].isNotEmpty) {
            defaultImage = vehicle.vehicleImage[0];
            defaultVehicleImage = vehicle.vehicleImage[0];
          } else {
            defaultImage = TImages.car; // Corrected string for default image
            defaultVehicleImage =
                TImages.car; // Corrected string for default image
          }
        } catch (e) {
          defaultVehicleImage =
              TImages.car; // Corrected string for default image
          defaultImage = TImages.car; // Corrected string for default image
        }

        bool isRented = false;

        String localRenterImage = '';
        String localRenterId = '';
        String localRenterName = '';
        String localRenterContactNumber = '';

        for (var rentedVehicle in rentedVehicles) {
          if (vehicle.vehicleId == rentedVehicle.vehicleId) {
            isRented = true;
            // defaultImage = '';
            for (RenterModel renter in renterController.rentersData) {
              if (renter.renterId == rentedVehicle.renterId) {
                try {
                  localRenterImage = renter.profilePicture != null &&
                          renter.profilePicture.isNotEmpty
                      ? renter.profilePicture
                      : TImages.profile;
                } catch (e) {
                  localRenterImage = TImages.profile;
                }
                localRenterId = renter.renterId;
                localRenterName = renter.userName;
                localRenterContactNumber = renter.contactNumber!;
              }
            }
            renterId = localRenterId;
            renterImage = localRenterImage;
            renterName = localRenterName;
            renterContactNumber = localRenterContactNumber;

            vehicleWidget = GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyGaragePageRented(
                            renterImage: localRenterImage,
                            renterName: localRenterName,
                            renterId: localRenterId,
                            vehicleId: vehicle.vehicleId,
                            model: vehicle.model,
                            renterContactNumber: localRenterContactNumber,
                            defaultVehicleImage: defaultImage,
                            isVehicleActive: vehicle.isVehicleActive,
                            rating: vehicle.rating.toString(),
                          )),
                );
              },
              child: GarageVehicleDetailsCardWidgets(
                renderImage: renterImage,
                renterName: renterName,
                vehicleImg: defaultVehicleImage,
                vehicleName: vehicle.model,
                ratingText: vehicle.rating.toString(),
                statusText: "Rented",
                statusFgColor: TColors.black,
                statusBgColor: Colors.green,
                handOverVehicleButton: () {},
              ),
            );
            vehicleWidgets.add(vehicleWidget);
            vehicleWidgets.add(SizedBox(height: 15));

            break; // Exit the rentedVehicles loop since we found the match
          }
        }

        if (!isRented) {
          for (BookingModel booking in bookingController.bookingsData) {
            if (vehicle.vehicleId == booking.vehicleId) {
              bookings.add(booking);
              print('bookings ${bookings[0].vehicleId}');
            }
          }
          vehicleWidget = GestureDetector(
            onTap: () {
              if (vehicle.isVehicleActive) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyGaragePageActive(
                      vehicleId: vehicle.vehicleId,
                      model: vehicle.model,
                      defaultVehicleImage: defaultImage,
                      isVehicleActive: vehicle.isVehicleActive,
                      rating: vehicle.rating.toString(),
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyGaragePageNotActive(
                      vehicleId: vehicle.vehicleId,
                      model: vehicle.model,
                      defaultVehicleImage: defaultImage,
                      isVehicleActive: vehicle.isVehicleActive,
                      rating: vehicle.rating.toString(),
                    ),
                  ),
                );
              }
            },
            child: GarageVehicleDetailsNotCardWidgets(
              vehicleImg: defaultVehicleImage,
              vehicleName: vehicle.model,
              ratingText: vehicle.rating.toString(),
              statusText: vehicle.isVehicleActive ? "Active" : "Non Active",
              statusFgColor: TColors.black,
              statusBgColor: Colors.blue.shade100,
              removeVehicleButton: () {
                showConfirmation(
                    context, vehicle.vehicleId, vehicle.model, vehicle.rating);
              },
            ),
          );
          vehicleWidgets.add(vehicleWidget);
          vehicleWidgets.add(SizedBox(height: 15));
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

    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: vehicleWidgets,
      ),
    ];
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
              return Text('Errorrr: ${snapshot.error}');
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          garageName.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Manage current vehicles,Add photos, modifications, and specs.',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 40),
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
                      child: vehicleList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SelectVehicleType()),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: TColors.primary,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
