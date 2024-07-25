// // ignore: file_names
// // ignore_for_file: prefer_const_constructors

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:xplorit/common_widgets/divider_widget.dart';
// import 'package:xplorit/common_widgets/order_summery_widget.dart';
// import 'package:xplorit/features/booking_status/vehicle_rental_widget.dart';
// import 'package:xplorit/utils/constants/image_strings.dart';
// import 'package:xplorit/utils/constants/sizes.dart';

// class BookingComplete extends StatefulWidget {
//   const BookingComplete({required this.renterId, Key? key}) : super(key: key);

//   final String renterId;
//   @override
//   State<BookingComplete> createState() => _BookingComplete();
// }

// class _BookingComplete extends State<BookingComplete> {
//   int bottomNavBarCurrentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(TSizes.defaultSpace),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 15),
//                 Text(
//                   'Completed Bookings',
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//                 const SizedBox(height: 10),
//                 VehicleRentalWidget(
//                     lenderImg: TImages.mountainBike,
//                     lender: "Manawala Rentals",
//                     lenderLocation: "Manawala",
//                     vehicleImg: TImages.mahendiraThar,
//                     vehicleName: "Mahendira Thar",
//                     ratingText: "4.9 (531 reviews)",
//                     startDate: Timestamp.now(),
//                     endDate: Timestamp.now(),
//                     statusText: 'Completed',
//                     statusFgColor: Colors.black,
//                     statusBgColor: Colors.green),
//                 OrderSummery(
//                   rentalRateType: 'Per day',
//                   noOfDays: 5,
//                   rentalRate: 1000,
//                 ),
//                 const SizedBox(height: 20),
//                 VehicleRentalWidget(
//                     lenderImg: TImages.mountainBike,
//                     lender: "Manawala Rentals",
//                     lenderLocation: "Manawala",
//                     vehicleImg: TImages.mahendiraThar,
//                     vehicleName: "Mahendira Thar",
//                     ratingText: "4.9 (531 reviews)",
//                     startDate: Timestamp.now(),
//                     endDate: Timestamp.now(),
//                     statusText: 'Completed',
//                     statusFgColor: Colors.black,
//                     statusBgColor: Colors.green),
//                 OrderSummery(
//                   rentalRateType: 'Per day',
//                   noOfDays: 5,
//                   rentalRate: 1000,
//                 ),
//                 DividerWidget()
//               ],
//             ),
//           ), //main Column
//         ),
//       ),
//     );
//   }
// }
// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/cancel_booking_controller.dart';
import 'package:xplorit/Controllers/completed_rent_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/completed_rent_model.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/common_widgets/order_summery_widget.dart';
import 'package:xplorit/features/booking_status/vehicle_rental_widget.dart';
// ignore: unused_import
import 'package:xplorit/utils/constants/image_strings.dart';

class BookingCompleted extends StatefulWidget {
  const BookingCompleted({required this.renterId, Key? key}) : super(key: key);

  final String renterId;
  @override
  State<BookingCompleted> createState() => _BookingCompleted();
}

class _BookingCompleted extends State<BookingCompleted> {
  int bottomNavBarCurrentIndex = 0;
  String garageImage = TImages.garageIcon;
  String garageLocation = '';
  double rating = 0.0;
  String model = '';
  int noOfRating = 0;
  int noOfDays = 0;
  String rentalRateType = '';
  double rentalRate = 0.0;
  String garageName = '';
  int selectedTabIndex = 0;
  String defaultVehicleImage = '';
  Timestamp endDate = Timestamp.fromDate(DateTime.now());
  Timestamp startDate = Timestamp.fromDate(DateTime.now());
  int rentedDuration = 1;
  List<CompletedRentModel> completedRents = [];
  List<BookingModel> bookingVehicles = [];
  final vehicleController = Get.put(VehicleController());
  final bookingController = Get.put(BookingController());
  final garageController = Get.put(GarageController());
  final cancelledBookingController = Get.put(CancelledBookingController());
  final completedRentController = Get.put(CompletedRentController());

  @override
  void initState() {
    super.initState();
    _initializeData();
    garageImage = TImages.garageIcon;
  }

// if(user?.phoneNumber == garage.renterId)
  Future<void> _initializeData() async {
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
        if (completedRent.renterId == widget.renterId) {
          completedRents.add(completedRent);
        }
      }
    } catch (error) {}
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchCompletedRentData() async {
    await completedRentController.fetchCompletedRentData();
  }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];
    Widget vehicleWidget;
    // for (VehicleModel vehicle in vehicleController.vehiclesData) {
    for (var completedRent in completedRents) {
      String defaultImage = '';
      for (VehicleModel vehicle in vehicleController.vehiclesData) {
        if (vehicle.vehicleId == completedRent.vehicleId) {
          try {
            if (vehicle.vehicleImage.isNotEmpty &&
                vehicle.vehicleImage[0].isNotEmpty) {
              defaultImage = vehicle.vehicleImage[0];
              defaultVehicleImage = vehicle.vehicleImage[0];
            } else {
              defaultImage = TImages.car;
              defaultVehicleImage = TImages.car;
            }
          } catch (e) {
            defaultVehicleImage = TImages.car;
            defaultImage = TImages.car;
          }
          model = vehicle.model;
          rating = vehicle.rating;
          noOfRating = vehicle.noOfRating;
          rentalRateType = vehicle.rentalRateType;
          rentalRate = vehicle.rentalRates;
        }
      }
      // for (BookingModel booking in bookingController.bookingsData) {
      //   if (booking.bookingId == completedRent.bookingId) {
      //     endDate = booking.endDate;
      //     startDate = booking.startDate;
      //     noOfDays = booking.duration;
      //   }
      // }

      for (GarageModel garage in garageController.garagesData) {
        if (garage.garageId == completedRent.garageId) {
          garageImage = TImages.garageIcon;
          garageName = garage.userName;
          garageLocation = garage.address;
        }
      }

      vehicleWidget = VehicleRentalWidget(
          lenderImg: garageImage,
          lender: garageName,
          lenderLocation: garageLocation,
          vehicleImg: defaultImage,
          vehicleName: model,
          ratingText: "$rating ($noOfRating Reviews)",
          startDate: completedRent.startDate,
          endDate: completedRent.endDate,
          statusText: 'Completed',
          statusFgColor: Colors.black,
          statusBgColor: Colors.green);

      vehicleWidgets.add(vehicleWidget);
      vehicleWidgets.add(const SizedBox(height: 10));
      vehicleWidgets.add(
        OrderSummery(
          rentalRateType: rentalRateType,
          noOfDays: completedRent.duration,
          rentalRate: rentalRate,
        ),
      );
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
