import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/Renter_chat/renter_chat_home_page.dart';
import 'package:xplorit/features/booking_status/booking_cancelled.dart';
import 'package:xplorit/features/booking_status/booking_card_widget.dart';
import 'package:xplorit/features/booking_status/booking_complete.dart';
import 'package:xplorit/features/booking_status/enter_rent_otp.dart';
import 'package:xplorit/features/booking_status/selction_Tab.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/dashbord/renter_profile/renter_profile_home.dart';
import 'package:xplorit/features/product/product_list.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);
  @override
  State<MyBookings> createState() => _MyBookings();
}

class _MyBookings extends State<MyBookings> {
  bool isConfirmCancelRequest = false;
  String garageImage = '';
  String garageId = '';
  String renterId = '';
  String vehicleModel = '';
  double vehicleRating = 0.0;
  int noOfVehicleRating = 0;
  String garageLocation = '';
  String garageName = '';
  int selectedTabIndex = 0;
  String defaultVehicleImage = '';
  int bottomNavBarCurrentIndex = 3;
  bool hasUnreadMessages = false;
  Timestamp endDate = Timestamp.fromDate(DateTime.now());
  Timestamp startDate = Timestamp.fromDate(DateTime.now());
  int rentedDuration = 1;
  List<RentedVehicleModel> rentedVehicles = [];
  List<BookingModel> bookingVehicles = [];
  final garageController = Get.put(GarageController());
  final bookingController = Get.put(BookingController());
  final vehicleController = Get.put(VehicleController());
  final rentedVehicleController = Get.put(RentedVehicleController());
  final completedRentController = Get.put(CompletedRentController());
  final cancelledBookingController = Get.put(CancelledBookingController());
  final renterController = Get.put(RenterController());

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchRenterId().then((_) async {
      await fetchVehicleData();
      await fetchBookingData();
      await fetchRentedVehicle();
      await fetchCancelledBookingData();
      await fetchCompletedRentData();
    }).catchError((e) {
      print("Error fetching renter ID: $e");
      return;
    }).then((_) {
      setState(() {});
    }).catchError((e) {
      print("Error fetching data: $e");
    });

    try {
      setState(() {});
    } catch (e) {}
  }

// if(user?.phoneNumber == garage.renterId)
  // Future<void> _initializeData() async {
  //   await fetchRenterId();
  //   // await fetchRenterData();
  //   await fetchVehicleData();
  //   await fetchBookingData();
  //   await fetchRentedVehicle();
  //   try {
  //     setState(() {});
  //   } catch (e) {}
  // }

  Future<void> removeExpiredBooking(Timestamp endDate) async {}

// Asynchronous method to fetch vehicle data
  Future<void> fetchVehicleData() async {
    await vehicleController.fetchVehicleData();
  }

  Future<void> fetchCompletedRentData() async {
    await completedRentController.fetchCompletedRentData();
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
        if (rentedVehicle.renterId == renterId) {
          rentedVehicles.add(rentedVehicle);
        }
      }
    } catch (error) {
      print('Error fetching rented vehicles: $error');
    }
  }

// Asynchronous method to fetch vehicle data
  Future<void> fetchBookingData() async {
    await bookingController.fetchBookingData();
  }

  void showAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      title: 'Success',
      text: 'Booking has been canceled successfully. Thank you.',
      type: QuickAlertType.success,
      confirmBtnColor: TColors.primary,
      confirmBtnText: 'Back to Home',
      onConfirmBtnTap: () {},
    );
  }

  Future<void> saveOTPToFirestore(
      String otp, String renterId, String lenderId, String vehicleId) async {
    await FirebaseFirestore.instance.collection('otps').doc(lenderId).set({
      'otp': otp,
      'renterId': renterId,
      'lenderId': lenderId,
      'vehicleId': vehicleId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> generateAndSaveOTP(
      String renterId, String lenderId, String vehicleId) async {
    String otp = generateOTP();
    await saveOTPToFirestore(otp, renterId, lenderId, vehicleId);
  }

  String generateOTP() {
    var rng = Random();
    return (100000 + rng.nextInt(900000)).toString();
  }

  Future<void> fetchRenterId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userPhoneNumber = user.phoneNumber ?? '';
      try {
        if (mounted) {
          var currentRenter = renterController.rentersData.firstWhere(
            (renter) => renter.contactNumber == userPhoneNumber,
            // orElse: () => RenterModel,
          );

          renterId = currentRenter != null && currentRenter.renterId.isNotEmpty
              ? currentRenter.renterId
              : '';
        }
      } catch (e) {
        renterId = '';
      }
    }
  }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];
    Widget vehicleWidget;
    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      // if (widget.renterId == vehicle.renterId) {
      String defaultImage = '';
      bool isRented = false;

      // Check if the vehicle is rented
      for (var rentedVehicle in rentedVehicles) {
        if (vehicle.vehicleId == rentedVehicle.vehicleId) {
          isRented = true;

          for (GarageModel garage in garageController.garagesData) {
            if (garage.garageId == rentedVehicle.garageId) {
              garageImage = TImages.garageIcon;
              garageName = garage.userName;
              garageLocation = garage.address;
              garageId = garage.garageId;
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

          vehicleWidget = BookingCard(
            lenderImg: garageImage,
            lender: garageName,
            lenderLocation: garageLocation,
            vehicleImg: defaultVehicleImage,
            vehicleName: vehicle.model,
            ratingText: vehicle.rating.toString(),
            noOfRating: vehicle.noOfRating,
            startDate: startDate,
            endDate: endDate,
            statusText: "Rented",
            statusFgColor: TColors.black,
            statusBgColor: Colors.green,
            cancelTapCall: () async {
              await generateAndSaveOTP(renterId, garageId, vehicle.vehicleId);

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EnterRentOtp(
                        vehicleId: vehicle.vehicleId,
                        renterId: renterId,
                        garageId: garageId)),
              );
              // Get.to(CancelBooking());
              // showCancelDialog(context);
            },
          );
          vehicleWidgets.add(vehicleWidget);
          vehicleWidgets.add(const SizedBox(height: 10));
          break;
        }
      }

      // If not rented, check if the vehicle is booked
      if (!isRented) {
        for (BookingModel bookingVehicle in bookingController.bookingsData) {
          if (bookingVehicle.vehicleId == vehicle.vehicleId) {
            if (bookingVehicle.renterId == renterId) {
              for (GarageModel garage in garageController.garagesData) {
                if (garage.garageId == vehicle.garageId) {
                  garageImage = TImages.garageIcon;
                  garageName = garage.userName;
                  garageLocation = garage.address;
                  garageId = garage.garageId;
                }
              }
              // await removeExpiredBooking(endDate);
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

              vehicleWidget = BookingCard(
                lenderImg: garageImage,
                lender: garageName,
                lenderLocation: garageLocation,
                vehicleImg: defaultImage,
                vehicleName: vehicle.model,
                ratingText: vehicle.rating.toString(),
                noOfRating: vehicle.noOfRating,
                startDate: bookingVehicle.startDate,
                endDate: bookingVehicle.endDate,
                statusText: "Pending",
                statusFgColor: Colors.red,
                statusBgColor: TColors.secondary,
                cancelTapCall: () {
                  // showCancelDialog(context);
                  showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevents dismissing by tapping outside the dialog

                      builder: (context) => AlertDialog(
                            title: const Text(
                              'Are you sure you want to cancel the booking?',
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      width: 120,
                                      child: ElevatedBTN(
                                          titleBtn: 'Yes',
                                          onTapCall: () {
                                            setState(() {
                                              bookingController
                                                  .removeBookingData(
                                                      bookingVehicle.bookingId);
                                              final cancelBooking =
                                                  CancelledBookingModel(
                                                cancelledBookingId: 'b1',
                                                bookingId:
                                                    bookingVehicle.bookingId,
                                                renterId:
                                                    bookingVehicle.renterId,
                                                vehicleId:
                                                    bookingVehicle.vehicleId,
                                                startDate:
                                                    bookingVehicle.startDate,
                                                endDate: bookingVehicle.endDate,
                                                canelledBy: 'Renter',
                                                garageId: garageId,
                                                garageName: garageName,
                                                garageLocation: garageLocation,
                                                vehicleImage: defaultImage,
                                                vehicleModel: vehicle.model,
                                                vehicleRating: vehicle.rating,
                                              );
                                              cancelledBookingController
                                                  .addCancelledBookingData(
                                                      cancelBooking);
                                            });
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Dashboard()),
                                              (Route<dynamic> route) => false,
                                            );
                                            // showAlert(context);
                                            // Navigator.of(context).pop(false);
                                          },
                                          btnColor: Colors.red)),
                                  SizedBox(
                                    width: 120,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text(
                                        'No',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                },
              );
              vehicleWidgets.add(vehicleWidget);
              vehicleWidgets.add(const SizedBox(height: 10));
              break;
            }
          }
        }
      }
      // }
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
    return PopScope(
      canPop: false, // Prevent back button from popping the current route
      child: Scaffold(
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                        (Route<dynamic> route) => false,
                      );
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
                        ? 'Lents and Requests'
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
                        DividerWidget(),
                      ],
                    )
                  else if (selectedTabIndex == 1)
                    BookingCompleted(
                      renterId: renterId,
                    )
                  else
                    BookingCancelled(
                      renterId: renterId,
                    ),
                  const SizedBox(height: 25),
                  // Other widgets based on selectedTabIndex
                ],
              ),
            ), //main Column
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
      ),
    );
  }
}
