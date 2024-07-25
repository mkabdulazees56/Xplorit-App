// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:xplorit/Controllers/cancel_booking_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/cancelled_booking_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/features/lent/lent_orders/lend_orders_cancelled_card_widget.dart';
import 'package:xplorit/features/lent/lent_orders/lent_orders.dart';
import 'package:xplorit/utils/constants/colors.dart';
// ignore: unused_import
import 'package:xplorit/utils/constants/image_strings.dart';

class LentOrdersCancelled extends StatefulWidget {
  const LentOrdersCancelled({required this.garageId, Key? key})
      : super(key: key);

  final String garageId;
  @override
  State<LentOrdersCancelled> createState() => _LentOrdersCancelled();
}

class _LentOrdersCancelled extends State<LentOrdersCancelled> {
  int bottomNavBarCurrentIndex = 0;
  String renterImage = '';
  String Location = '';
  String renterName = '';
  int selectedTabIndex = 0;
  String defaultVehicleImage = '';
  Timestamp endDate = Timestamp.fromDate(DateTime.now());
  Timestamp startDate = Timestamp.fromDate(DateTime.now());
  int rentedDuration = 1;
  List<CancelledBookingModel> cancelledBookingVehicles = [];
  List<BookingModel> bookingVehicles = [];
  final vehicleController = Get.put(VehicleController());
  final renterController = Get.put(RenterController());
  final cancelledBookingController = Get.put(CancelledBookingController());

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await fetchCancelledBookingData();
    await fetchCancelledBookingVehicle();
    await fetchRenterData();
    try {
      setState(() {});
    } catch (e) {}
  }

  Future<void> fetchRenterData() async {
    await renterController.fetchRenterData();
  }

  Future<void> fetchCancelledBookingVehicle() async {
    try {
      for (CancelledBookingModel cancelledBookingVehicle
          in cancelledBookingController.cancelledbookingsData) {
        if (cancelledBookingVehicle.garageId == widget.garageId) {
          cancelledBookingVehicles.add(cancelledBookingVehicle);
        }
      }
    } catch (error) {
      print('Error fetching rented vehicles: $error');
    }
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchCancelledBookingData() async {
    await cancelledBookingController.fetchCancelledBookingData();
  }

  void showAlert(String cancelledBookingId, BuildContext context) {
    QuickAlert.show(
        context: context,
        title: 'Delete',
        text: 'Are you sure you \nwant to remove this data?',
        type: QuickAlertType.warning,
        confirmBtnColor: TColors.primary,
        confirmBtnText: 'Start Delete',
        onConfirmBtnTap: () {
          setState(() {
            cancelledBookingController
                .removeCancelledBookingData(cancelledBookingId);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LentOrders(
                        garageId: widget.garageId,
                      )),
            );
          });
        }
        // barrierDismissible: false, // Prevents closing when tapping outside
        );
  }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];
    Widget vehicleWidget;
    // for (VehicleModel vehicle in vehicleController.vehiclesData) {
    for (var cancelledBookingVehicle in cancelledBookingVehicles) {
      String defaultImage = '';
      try {
        if (cancelledBookingVehicle.vehicleImage.isNotEmpty) {
          defaultImage = cancelledBookingVehicle.vehicleImage;
          defaultVehicleImage = cancelledBookingVehicle.vehicleImage;
        } else {
          defaultImage = 'TImage.person';
          defaultVehicleImage = 'TImage.person';
        }
      } catch (e) {
        defaultVehicleImage = 'TImage.person';
        defaultImage = 'TImage.person';
      }

      for (RenterModel renter in renterController.rentersData) {
        if (renter.renterId == cancelledBookingVehicle.renterId) {
          try {
            renterImage = renter.profilePicture != null &&
                    renter.profilePicture.isNotEmpty
                ? renter.profilePicture
                : TImages.profile;
          } catch (e) {
            renterImage = TImages.profile;
          }
          renterName = renter.userName;
        }
      }
      vehicleWidget = LendOrdersCancelledCardWidget(
        renderImg: renterImage,
        renterName: renterName,
        // lenderLocation: cancelledBookingVehicle.garageLocation,
        vehicleImg: cancelledBookingVehicle.vehicleImage,
        vehicleName: cancelledBookingVehicle.vehicleModel,
        ratingText: cancelledBookingVehicle.vehicleRating.toString(),
        startDate: cancelledBookingVehicle.startDate,
        endDate: cancelledBookingVehicle.endDate,
        statusText: 'Cancelled by ${cancelledBookingVehicle.canelledBy}',
        statusFgColor: Colors.red,
        statusBgColor: TColors.grey,
        trackVehicleTapCall: () {
          // setState(() {
          showAlert(cancelledBookingVehicle.cancelledBookingId, context);
          // });
        },
      );
      vehicleWidgets.add(vehicleWidget);
      vehicleWidgets.add(const SizedBox(height: 10));
    }
    // }

    if (vehicleWidgets.isEmpty) {
      vehicleWidgets.add(
        const Center(
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
        return const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [vehicleList(), DividerWidget()],
    );
  }
}

// // // ignore: file_names
// // // ignore_for_file: prefer_const_constructors

// // import 'package:flutter/material.dart';
// // import 'package:xplorit/common_widgets/divider_widget.dart';
// // import 'package:xplorit/features/lent/lent_orders/lend_orders_cancelled_card_widget.dart';
// // import 'package:xplorit/utils/constants/colors.dart';
// // import 'package:xplorit/utils/constants/image_strings.dart';

// // class LentOrdersCancelled extends StatefulWidget {
// //   const LentOrdersCancelled({Key? key}) : super(key: key);
// //   @override
// //   State<LentOrdersCancelled> createState() => _LentOrdersCancelled();
// // }

// // class _LentOrdersCancelled extends State<LentOrdersCancelled> {
// //   int bottomNavBarCurrentIndex = 0;
// //   int selectedTabIndex = 0;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         LendOrdersCancelledCardWidget(
// //           renderImg: TImages.mountainBike,
// //           renderImgScale: 20,
// //           renterName: "Jawad Jamil",
// //           vehicleImg: TImages.mahendiraThar,
// //           vehicleName: "Mahendira Thar",
// //           ratingText: "4.9 (531 reviews)",
// //           idText: "ID :- 1605DXB",
// //           imgScale: 3,
// //           startDate: '1/1/2024',
// //           statusText: "Cancelled",
// //           statusFgColor: TColors.black,
// //           statusBgColor: Colors.redAccent.shade100,
// //         ),
// //         SizedBox(
// //           height: 10,
// //         ),
// //         LendOrdersCancelledCardWidget(
// //           renderImg: TImages.profile,
// //           renderImgScale: 20,
// //           renterName: "Abdul Azees",
// //           vehicleImg: TImages.autoBajaj,
// //           vehicleName: "Rickshaw Bajaj RE",
// //           ratingText: "4.9 (531 reviews)",
// //           idText: "ID :- 1605DXB",
// //           imgScale: 7,
// //           startDate: '1/1/2024',
// //           statusText: "Cancelled",
// //           statusFgColor: TColors.black,
// //           statusBgColor: Colors.redAccent.shade100,
// //         ),
// //         DividerWidget()
// //       ],
// //     );
// //   }
// // }

// // ignore: file_names
// // ignore_for_file: prefer_const_constructors

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:xplorit/Controllers/booking_controller.dart';
// import 'package:xplorit/Controllers/renter_controller.dart';
// import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
// import 'package:xplorit/Controllers/vehicle_controller.dart';
// import 'package:xplorit/Models/booking_model.dart';
// import 'package:xplorit/Models/rented_vehicle_model.dart';
// import 'package:xplorit/Models/renter_model.dart';
// import 'package:xplorit/Models/vehicle_model.dart';
// import 'package:xplorit/common_widgets/divider_widget.dart';
// import 'package:xplorit/features/lent/lent_orders/lend_orders_cancelled_card_widget.dart';
// import 'package:xplorit/utils/constants/colors.dart';
// import 'package:xplorit/utils/constants/image_strings.dart';

// class LentOrdersCancelled extends StatefulWidget {
//   const LentOrdersCancelled({required this.garageId, Key? key})
//       : super(key: key);

//   final String garageId;
//   @override
//   State<LentOrdersCancelled> createState() => _LentOrdersCancelled();
// }

// class _LentOrdersCancelled extends State<LentOrdersCancelled> {
//   int bottomNavBarCurrentIndex = 0;
//   int selectedTabIndex = 0;

//   int rentalRate = 0;
//   String renterImage = '';
//   String renterName = '';
//   String defaultVehicleImage = '';
//   Timestamp endDate = Timestamp.fromDate(DateTime.now());
//   Timestamp startDate = Timestamp.fromDate(DateTime.now());
//   int rentedDuration = 1;
//   List<RentedVehicleModel> rentedVehicles = [];
//   final renterController = Get.put(RenterController());
//   final bookingController = Get.put(BookingController());
//   final vehicleController = Get.put(VehicleController());
//   final rentedVehicleController = Get.put(RentedVehicleController());

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

// // if(user?.phoneNumber == garage.garageId)
//   Future<void> _initializeData() async {
//     await fetchRentedVehicle();
//   }

//   Future<void> fetchRentedVehicle() async {
//     try {
//       for (RentedVehicleModel rentedVehicle
//           in rentedVehicleController.rentedvehiclesData) {
//         if (rentedVehicle.garageId == widget.garageId) {
//           rentedVehicles.add(rentedVehicle);
//         }
//       }
//     } catch (error) {
//       print('Error fetching rented vehicles: $error');
//     }
//   }

//   Future<List<Widget>> _buildVehicleWidgets() async {
//     List<Widget> vehicleWidgets = [];
//     Widget vehicleWidget;

//     for (VehicleModel vehicle in vehicleController.vehiclesData) {
//       if (widget.garageId == vehicle.garageId) {
//         String defaultImage = '';
//         try {
//           if (vehicle.vehicleImage.isNotEmpty &&
//               vehicle.vehicleImage[0].isNotEmpty) {
//             defaultImage = vehicle.vehicleImage[0];
//             defaultVehicleImage = vehicle.vehicleImage[0];
//           } else {
//             defaultImage = 'TImage.person';
//             defaultVehicleImage = 'TImage.person';
//           }
//         } catch (e) {
//           defaultVehicleImage = 'TImage.person';
//           defaultImage = 'TImage.person';
//         }

//         for (var rentedVehicle in rentedVehicles) {
//           if (vehicle.vehicleId == rentedVehicle.vehicleId) {
//             rentalRate = vehicle.rentalRates.toInt();
//             for (RenterModel renter in renterController.rentersData) {
//               if (renter.garageId == rentedVehicle.garageId) {
//                 try {
//                   renterImage = renter.profilePicture != null &&
//                           renter.profilePicture.isNotEmpty
//                       ? renter.profilePicture
//                       : TImages.profile;
//                 } catch (e) {
//                   renterImage = TImages.profile;
//                 }
//                 renterName = renter.userName;
//               }
//             }
//             for (BookingModel booking in bookingController.bookingsData) {
//               if (booking.bookingId == rentedVehicle.bookingId) {
//                 startDate = booking.startDate;
//                 endDate = booking.endDate;
//                 rentedDuration = booking.duration;
//               }
//             }
//             vehicleWidget = LendOrdersCancelledCardWidget(
//               renderImg: renterImage,
//               renterName: renterName,
//               vehicleImg: defaultVehicleImage,
//               vehicleName: vehicle.model,
//               ratingText: vehicle.rating.toString(),
//               endDate: endDate,
//               statusText: "Cancelled",
//               statusFgColor: TColors.black,
//               statusBgColor: Colors.redAccent.shade100,
//             );
//             vehicleWidgets.add(vehicleWidget);
//             vehicleWidgets.add(const SizedBox(height: 10));
//           }
//         }
//       }
//     }

//     if (vehicleWidgets.isEmpty) {
//       vehicleWidgets.add(
//         Center(
//           child: Text('No vehicles available'),
//         ),
//       );
//     }

//     return [
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: vehicleWidgets,
//       ),
//     ];
//   }

//   Widget vehicleList() {
//     return Obx(() {
//       if (vehicleController.isLoading.value) {
//         return const Center(
//             child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(child: CircularProgressIndicator()),
//           ],
//         ));
//       } else if (vehicleController.vehiclesData.isEmpty) {
//         return Text('No vehicles available');
//       } else {
//         return FutureBuilder<List<Widget>>(
//           future: _buildVehicleWidgets(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               print('Error: ${snapshot.error}');
//               return Text('Errorrr: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Text('No vehicles available');
//             } else {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: snapshot.data!,
//               );
//             }
//           },
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [vehicleList(), DividerWidget()],
//     );
//   }
// }
