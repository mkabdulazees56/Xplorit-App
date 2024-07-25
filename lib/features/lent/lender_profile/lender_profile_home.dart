// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/cancel_booking_controller.dart';
import 'package:xplorit/Controllers/completed_rent_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/cancelled_booking_model.dart';
import 'package:xplorit/Models/completed_rent_model.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/rented_vehicle_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/Lender_chat/chat_home_page.dart';
import 'package:xplorit/features/athuntication/screens/auth_controller.dart';
import 'package:xplorit/features/athuntication/screens/mode_selection.dart';
import 'package:xplorit/features/athuntication/screens/signupwithphExistingUser.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/features/lent/lender_profile/garage_profile.dart';
import 'package:xplorit/features/lent/lender_profile/lender_profile_aboutus.dart';
import 'package:xplorit/features/lent/lender_profile/lender_profile_card_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class LenderProfileHomePage extends StatefulWidget {
  const LenderProfileHomePage({super.key});

  @override
  State<LenderProfileHomePage> createState() => _LenderProfileHomePageState();
}

class _LenderProfileHomePageState extends State<LenderProfileHomePage> {
  bool isSwitched = false;
  bool isLender = false;
  int bottomNavBarCurrentIndex = 2;
  final isSignOutLoading = false.obs;
  final isDeleteLoading = false.obs;
  String userPhoneNumber = '';
  String profilePicture = TImages.profile;
  final renterController = Get.put(RenterController());
  final vehicleController = Get.put(VehicleController());
  final rentedVehicleController = Get.put(RentedVehicleController());
  final bookingController = Get.put(BookingController());
  final completedRentController = Get.put(CompletedRentController());
  final cancelledBookingController = Get.put(CancelledBookingController());
  final AuthController authController = AuthController();
  final garageController = Get.put(GarageController());
  String garageName = 'Your Garage';
  String garageId = '';
  List<VehicleModel> myVehicles = [];
  bool myVehicleIsRented = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await fetchGarageId();
    await fetchRenterData();
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
              });
            } catch (r) {
              garageName = garage.userName;
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
              });
            } catch (r) {
              garageName = garage.userName;
            }
          }
        }
      }
    }
  }

  // Asynchronous method to fetch garage data
  Future<void> fetchRenterData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userPhoneNumber = user.phoneNumber ?? '';
      });
      for (RenterModel renter in renterController.rentersData) {
        if (userPhoneNumber == renter.contactNumber) {
          setState(() {
            isLender = true;
          });
        }
      }
    }
  }

  showConfirmation(context) {
    return showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing by tapping outside the dialog

        builder: (context) => AlertDialog(
              title: const Text(
                'No renter account exists for this phone number. Would you like to create a new lender account',
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
                              Get.to(() => signupwithphExistingUser(
                                  newUserType: 'renter',
                                  phoneNumber: userPhoneNumber));
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
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }

  showDeleteAccountConfirmation(context) {
    return showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing by tapping outside the dialog

        builder: (context) => AlertDialog(
              title: const Text(
                'Are you sure, \nyou want to delete the account',
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
                              deleteAccount();
                            },
                            btnColor: Colors.red)),
                    SizedBox(width: 5),
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
            ));
  }

  showErrorDeleteAccount(context) {
    return showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing by tapping outside the dialog

        builder: (context) => AlertDialog(
              title: const Text(
                'Some of your vehicles are currently rented.\nPlease ensure all vehicles are returned before deleting your account.',
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: 120,
                        child: ElevatedBTN(
                            titleBtn: 'Ok',
                            onTapCall: () {
                              Navigator.of(context).pop(false);
                            },
                            btnColor: Colors.red)),
                  ],
                ),
              ],
            ));
  }

  void deleteAccount() {
    for (RentedVehicleModel rentedVehicle
        in rentedVehicleController.rentedvehiclesData) {
      if (garageId == rentedVehicle.garageId) {
        myVehicleIsRented = true;
        break;
      }
    }

    if (myVehicleIsRented) {
      Navigator.of(context).pop(false);
      showErrorDeleteAccount(context);
    } else {
      for (BookingModel booking in bookingController.bookingsData) {
        if (garageId == booking.garageId) {
          bookingController.removeBookingData(booking.bookingId);
        }
      }

      for (CompletedRentModel completedRent
          in completedRentController.completedRentsData) {
        if (garageId == completedRent.garageId) {
          completedRentController
              .removeCompletedRentData(completedRent.completedRentId);
        }
      }

      for (CancelledBookingModel cancelledBooking
          in cancelledBookingController.cancelledbookingsData) {
        if (garageId == cancelledBooking.garageId) {
          completedRentController
              .removeCompletedRentData(cancelledBooking.cancelledBookingId);
        }
      }

      for (VehicleModel vehicle in vehicleController.vehiclesData) {
        if (garageId == vehicle.garageId) {
          vehicleController.removeVehicleData(vehicle.vehicleId);
        }
      }
      garageController.removeGarageData(garageId);
      authController.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      Get.offAll(() => HomelentPage());
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                      color: Colors
                          .black, // Use btnColor if provided, otherwise use default color
                    ),
                    label: Text(
                      'Back',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors
                              .black), // Use btnColor if provided, otherwise use default color
                    ),
                  ),
                  // BackButtonWidget(
                  //   btnColor: TColors.black,
                  // ),
                ),
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  TImages.garageIcon,
                  scale: 5,
                ),
                SizedBox(height: 10),
                Text(garageName.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      LenderProfileCardWidget(
                          icon: Icons.person,
                          txt: 'My Profile',
                          tapCal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GarageProfile()),
                            );
                          }),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // LenderProfileCardWidget(
                      //     icon: Icons.lock, txt: 'Change Password'),
                      SizedBox(
                        height: 20,
                      ),
                      LenderProfileCardWidget(
                          icon: Icons.details,
                          txt: 'About Us',
                          tapCal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUs()),
                            );
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: TColors.secondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Change to Rent Mode',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'By activating this you will \n be redirected to your rent app',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                          if (isSwitched) {
                            if (isLender) {
                              Get.to(() => ModeSelection(userStatus: true));
                            } else {
                              setState(() {
                                isSwitched = false;
                              });
                              showConfirmation(context);
                            }
                          }
                        },
                        activeColor: TColors.primary,
                        inactiveThumbColor: TColors.darkGrey,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Obx(
                  () {
                    return isSignOutLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: TColors.primary,
                              backgroundColor: Colors.transparent,
                            ),
                          )
                        : ElevatedBTN(
                            titleBtn: 'Sign Out',
                            onTapCall: () => {
                              authController.signOut(),
                            },
                          );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    return isSignOutLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: TColors.primary,
                              backgroundColor: Colors.transparent,
                            ),
                          )
                        : ElevatedBTN(
                            titleBtn: 'Delete Account',
                            onTapCall: () => {
                              showDeleteAccountConfirmation(context)
                              // authController.deleteAccount(),
                            },
                            btnColor: Colors.redAccent,
                          );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNavBarCurrentIndex,
          unselectedItemColor: TColors.greyDark,
          selectedItemColor: TColors.primary,
          backgroundColor: TColors.blueLight,
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox),
              label: 'Inbox',
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
                Get.offAll(() => HomelentPage());
                break;
              case 1:
                Get.offAll(() => LenderChatHomePage());
                break;
              case 2:
                Get.offAll(() => LenderProfileHomePage());
                break;
            }
          },
        ),
      ),
    );
  }
}
