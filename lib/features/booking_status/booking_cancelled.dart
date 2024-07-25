// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/cancel_booking_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/cancelled_booking_model.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/features/booking_status/booking_card_widget.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/utils/constants/colors.dart';
// ignore: unused_import
import 'package:xplorit/utils/constants/image_strings.dart';

class BookingCancelled extends StatefulWidget {
  const BookingCancelled({required this.renterId, Key? key}) : super(key: key);

  final String renterId;
  @override
  State<BookingCancelled> createState() => _BookingCancelled();
}

class _BookingCancelled extends State<BookingCancelled> {
  int bottomNavBarCurrentIndex = 0;
  String garageImage = '';
  String garageLocation = '';
  String garageName = '';
  int selectedTabIndex = 0;
  String defaultVehicleImage = '';
  Timestamp endDate = Timestamp.fromDate(DateTime.now());
  Timestamp startDate = Timestamp.fromDate(DateTime.now());
  int rentedDuration = 1;
  List<CancelledBookingModel> cancelledBookingVehicles = [];
  List<BookingModel> bookingVehicles = [];
  final vehicleController = Get.put(VehicleController());
  final cancelledBookingController = Get.put(CancelledBookingController());

  @override
  void initState() {
    super.initState();
    _initializeData();
    garageImage = TImages.garageIcon;
  }

// if(user?.phoneNumber == garage.renterId)
  Future<void> _initializeData() async {
    await fetchCancelledBookingData();
    await fetchCancelledBookingVehicle();
    setState(() {});
  }

  Future<void> fetchCancelledBookingVehicle() async {
    try {
      for (CancelledBookingModel cancelledBookingVehicle
          in cancelledBookingController.cancelledbookingsData) {
        if (cancelledBookingVehicle.renterId == widget.renterId) {
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
          defaultImage = TImages.car;
          defaultVehicleImage = TImages.car;
        }
      } catch (e) {
        defaultVehicleImage = TImages.car;
        defaultImage = TImages.car;
      }

      vehicleWidget = BookingCard(
        lenderImg: garageImage,
        lender: cancelledBookingVehicle.garageName,
        lenderLocation: cancelledBookingVehicle.garageLocation,
        vehicleImg: defaultImage,
        vehicleName: cancelledBookingVehicle.vehicleModel,
        ratingText: cancelledBookingVehicle.vehicleRating.toString(),
        noOfRating: 0,
        startDate: cancelledBookingVehicle.startDate,
        endDate: cancelledBookingVehicle.endDate,
        statusText: cancelledBookingVehicle.canelledBy == 'Booking Expired'
            ? cancelledBookingVehicle.canelledBy
            : 'Cancelled by ${cancelledBookingVehicle.canelledBy}',
        statusFgColor: Colors.red,
        statusBgColor: TColors.grey,
        cancelTapCall: () {
          setState(() {
            cancelledBookingController.removeCancelledBookingData(
                cancelledBookingVehicle.cancelledBookingId);
          });
          Get.offAll(() => Dashboard());
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
