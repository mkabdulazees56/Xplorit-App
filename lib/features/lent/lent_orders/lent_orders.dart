import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/cancel_booking_controller.dart';
import 'package:xplorit/Controllers/completed_rent_controller.dart';
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
import 'package:xplorit/features/booking_status/selction_Tab.dart';
import 'package:xplorit/features/lent/garage/track_vehicle.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/features/lent/lent_orders/lend_orders_cancelled.dart';
import 'package:xplorit/features/lent/lent_orders/lend_orders_completed.dart';
import 'package:xplorit/features/lent/lent_orders/lend_orders_lent_card_widgets.dart';
import 'package:xplorit/features/lent/lent_orders/lend_orders_request_card_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class LentOrders extends StatefulWidget {
  const LentOrders({required this.garageId, Key? key}) : super(key: key);

  final String garageId;
  @override
  State<LentOrders> createState() => _LentOrders();
}

class _LentOrders extends State<LentOrders> {
  String renterImage = '';
  String renterName = '';
  String renterId = '';
  double renterRating = 0.0;
  int renterNoOfRating = 0;
  String renterContactNumber = '';
  String garageLocation = '';
  String garageImage = '';
  String garageId = '';
  String garageName = '';
  String vehicleModel = '';
  double vehicleRating = 0.0;
  int selectedTabIndex = 0;
  String defaultVehicleImage = '';
  int bottomNavBarCurrentIndex = 0;
  Timestamp endDate = Timestamp.fromDate(DateTime.now());
  Timestamp startDate = Timestamp.fromDate(DateTime.now());
  int rentedDuration = 1;
  List<RentedVehicleModel> rentedVehicles = [];
  List<BookingModel> bookingVehicles = [];
  final renterController = Get.put(RenterController());
  final bookingController = Get.put(BookingController());
  final cancelledBookingController = Get.put(CancelledBookingController());
  final garageController = Get.put(GarageController());
  final vehicleController = Get.put(VehicleController());
  final rentedVehicleController = Get.put(RentedVehicleController());

  // final cancelledBookingController = Get.put(CancelledBookingController());
  // final rentedVehicleController = Get.put(RentedVehicleController());
  final completedRentController = Get.put(CompletedRentController());

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await fetchRentedVehicle();
    await fetchRenterData();
    await fetchVehicleData();
    await fetchBookingData();
    await fetchCompletedRentData();
    await fetchCancelledBookingData();
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchVehicleData() async {
    await vehicleController.fetchVehicleData();
  }

  Future<void> fetchCompletedRentData() async {
    await completedRentController.fetchCompletedRentData();
  }

  Future<void> fetchRenterData() async {
    await renterController.fetchRenterData();
  }

  Future<void> fetchCancelledBookingData() async {
    await cancelledBookingController.fetchCancelledBookingData();
  }

  Future<void> fetchRentedVehicle() async {
    try {
      await rentedVehicleController.fetchRentedVehicleData();
    } catch (e) {}
    try {
      for (RentedVehicleModel rentedVehicle
          in rentedVehicleController.rentedvehiclesData) {
        if (rentedVehicle.garageId == widget.garageId) {
          rentedVehicles.add(rentedVehicle);
        }
      }
    } catch (error) {
      print('Error fetching rented vehicles: $error');
    }
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchBookingData() async {
    setState(() {});
    await bookingController.fetchBookingData();
  }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];
    Widget vehicleWidget;
    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      if (widget.garageId == vehicle.garageId) {
        String defaultImage = '';

        // Check if the vehicle is rented
        bool isRented = false;
        for (var rentedVehicle in rentedVehicles) {
          if (vehicle.vehicleId == rentedVehicle.vehicleId) {
            isRented = true;

            for (RenterModel renter in renterController.rentersData) {
              if (renter.renterId == rentedVehicle.renterId) {
                try {
                  renterImage = renter.profilePicture != null &&
                          renter.profilePicture.isNotEmpty
                      ? renter.profilePicture
                      : TImages.profile;
                } catch (e) {
                  renterImage = TImages.profile;
                }
                renterName = renter.userName;
                renterId = renter.renterId;
                renterRating = renter.rating;
                renterNoOfRating = renter.noOfRating;
                renterContactNumber = renter.contactNumber!;
              }
            }

            for (BookingModel booking in bookingController.bookingsData) {
              if (booking.bookingId == rentedVehicle.bookingId) {
                startDate = booking.startDate;
                endDate = booking.endDate;
                rentedDuration = booking.duration;
              }
            }
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
            vehicleWidget = LendOrdersLentCardWidget(
              renderImg: renterImage,
              renterName: renterName,
              vehicleImg: defaultImage,
              vehicleName: vehicle.model,
              renterNoOfRating: renterNoOfRating,
              renterRatingText: renterRating.toString(),
              vehicleRatingText: vehicle.rating.toString(),
              vehicleNoOfRating: vehicle.noOfRating,
              startDate: startDate,
              endDate: endDate,
              statusText: 'Lent',
              statusFgColor: TColors.black,
              statusBgColor: Colors.green,
              trackVehicleTapCall: () {
                Get.to(() => TrackVehiclePage(
                      model: vehicle.model,
                      renterId: renterId,
                      renterImage: renterImage,
                      renterName: renterName,
                      defaultVehicleImage: defaultImage,
                    ));
              },
              buttonText: 'Track the Vehicle',
              renterContactNumber: renterContactNumber,
              renterId: renterId,
            );
            vehicleWidgets.add(vehicleWidget);
            vehicleWidgets.add(const SizedBox(height: 10));
            break; // Only break out of the rented vehicle loop
          }
        }

        // If not rented, check if the vehicle is booked
        if (!isRented) {
          for (BookingModel bookingVehicle in bookingController.bookingsData) {
            if (bookingVehicle.vehicleId == vehicle.vehicleId) {
              for (RenterModel renter in renterController.rentersData) {
                if (renter.renterId == bookingVehicle.renterId &&
                    !renter.isRentedAVehicle) {
                  renterImage = renter.profilePicture.isNotEmpty == true
                      ? renter.profilePicture
                      : TImages.profile;
                  renterName = renter.userName;
                  renterRating = renter.rating;
                  renterNoOfRating = renter.noOfRating;

                  for (GarageModel garage in garageController.garagesData) {
                    if (garage.garageId == widget.garageId) {
                      garageImage = TImages.garageIcon;
                      garageName = garage.userName;
                      garageLocation = garage.address;
                    }
                  }
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
                  vehicleWidget = LendOrdersRequestCardWidget(
                    renderImg: renterImage,
                    renterName: renterName,
                    vehicleImg: defaultImage,
                    vehicleName: vehicle.model,
                    renterRatingtEXT: renterRating.toString(),
                    renterNoOfRating: renterNoOfRating,
                    vehicleRatingtEXT: vehicle.rating.toString(),
                    vehicleNoOfRating: vehicle.noOfRating,
                    startDate: bookingVehicle.startDate,
                    endDate: bookingVehicle.endDate,
                    statusText: 'Request',
                    statusFgColor: TColors.primary,
                    statusBgColor: Colors.blue,
                    trackVehicleTapCall: () {
                      setState(() {
                        final rent = RentedVehicleModel(
                          rentId: 'r1',
                          bookingId: bookingVehicle.bookingId,
                          vehicleId: bookingVehicle.vehicleId,
                          garageId: widget.garageId,
                          renterId: bookingVehicle.renterId,
                        );
                        rentedVehicleController.addRentedVehicleData(
                            rent, context);
                        vehicleController.updateVehicleActiveStatus(
                            bookingVehicle.vehicleId, false);
                        renterController.updateRenterActiveStatus(
                            bookingVehicle.renterId, true);
                      });
                    },
                    declineTapCall: () {
                      setState(() {
                        QuickAlert.show(
                            context: context,
                            title: 'Decline',
                            text:
                                'Are you sure you \nwant to decline this request?',
                            type: QuickAlertType.warning,
                            confirmBtnColor: TColors.primary,
                            confirmBtnText: 'Decline Request',
                            onConfirmBtnTap: () {
                              setState(() {
                                bookingController.removeBookingData(
                                    bookingVehicle.bookingId);
                                final cancelBooking = CancelledBookingModel(
                                  cancelledBookingId: 'b1',
                                  bookingId: bookingVehicle.bookingId,
                                  renterId: bookingVehicle.renterId,
                                  vehicleId: bookingVehicle.vehicleId,
                                  startDate: bookingVehicle.startDate,
                                  endDate: bookingVehicle.endDate,
                                  canelledBy: 'Lender',
                                  garageId: widget.garageId,
                                  garageName: garageName,
                                  garageLocation: garageLocation,
                                  vehicleImage: defaultImage,
                                  vehicleModel: vehicle.model,
                                  vehicleRating: vehicle.rating,
                                );
                                cancelledBookingController
                                    .addCancelledBookingData(cancelBooking);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LentOrders(
                                            garageId: widget.garageId,
                                          )),
                                );
                                Get.to(() => const HomelentPage());
                              });
                            } // barrierDismissible: false, // Prevents closing when tapping outside
                            );
                      });
                    },
                    buttonText: 'Accept',
                  );
                  vehicleWidgets.add(vehicleWidget);
                  vehicleWidgets.add(const SizedBox(height: 10));
                  // No break here, continue to check for other bookings of the same vehicle
                }
              }
            }
          }
        }
      }
    }

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BackButtonWidget(),
                TextButton.icon(
                  onPressed: () {
                    Get.to(() => HomelentPage());
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                    color: TColors.black,
                  ),
                  label: Text(
                    'Back',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: TColors.black),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Orders',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                TSelcetionTab(
                  onTap1: () {
                    setState(() {
                      selectedTabIndex = 0;
                    });
                  },
                  onTap2: () {
                    setState(() {
                      selectedTabIndex = 1;
                    });
                  },
                  onTap3: () {
                    setState(() {
                      selectedTabIndex = 2;
                    });
                  },
                ),
                const SizedBox(height: 15),
                Text(
                  selectedTabIndex == 0
                      ? 'Lent and Requests'
                      : selectedTabIndex == 1
                          ? 'Completed Rents'
                          : 'Cancelled and Expired Bookings',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                // Use conditional rendering based on selectedTabIndex
                if (selectedTabIndex == 0)
                  Column(
                    children: [
                      vehicleList(),
                      // LendOrdersPendingCardWidget(
                      //   renderImg: 'TImages.profile',
                      //   renderImgScale: 2,
                      //   renterName: renterName,
                      //   vehicleImg: 'TImages.profile',
                      //   vehicleName: 'vehicleName',
                      //   ratingText: 'ratingText',
                      //   idText: 'idText',
                      //   imgScale: 2,
                      //   startDate: 'startDate',
                      //   endDate: 'endDate',
                      //   statusText: 'statusText',
                      //   statusFgColor: Colors.blue,
                      //   statusBgColor: Colors.yellow,
                      //   trackVehicleTapCall: () {},
                      //   buttonText: 'buttonText',
                      // )
                    ],
                  )
                else if (selectedTabIndex == 1)
                  LentOrdersCompleted(
                    garageId: widget.garageId,
                  )
                else
                  LentOrdersCancelled(
                    garageId: widget.garageId,
                  ),
                const SizedBox(height: 25),
                // Other widgets based on selectedTabIndex
              ],
            ),
          ), //main Column
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: bottomNavBarCurrentIndex,
      //   unselectedItemColor: TColors.darkGrey,
      //   selectedItemColor: TColors.primary,
      //   backgroundColor: TColors.secondary,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: 'Alerts',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.all_inbox),
      //       label: 'Bookings',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Account',
      //     ),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       bottomNavBarCurrentIndex = index;
      //     });
      //     switch (index) {
      //       case 0:
      //         Get.to(() => HomelentPage());
      //         break;
      //       case 1:
      //         Get.to(() => ProductListing());
      //         break;
      //       case 2:
      //         Get.to(() => const ModeSelection(userStatus: true));
      //         // Navigator.pushNamed(context, '/alerts');
      //         break;
      //       case 3:
      //         // No need to navigate if already on the same screen
      //         if (selectedTabIndex != 0) {
      //           setState(() {
      //             selectedTabIndex = 0;
      //           });
      //         }
      //         break;
      //       case 4:
      //         Get.to(() => LentOrders(
      //               garageId: widget.garageId,
      //             ));
      //         break;
      //     }
      //   },
      // ),
    );
  }
}
