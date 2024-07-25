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
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/Renter_chat/renter_chat_home_page.dart';
import 'package:xplorit/features/athuntication/screens/auth_controller.dart';
import 'package:xplorit/features/athuntication/screens/mode_selection.dart';
import 'package:xplorit/features/athuntication/screens/signupwithphExistingUser.dart';
import 'package:xplorit/features/booking_status/my_bookings.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/dashbord/renter_profile/lender_profile_card_widget.dart';
import 'package:xplorit/features/dashbord/renter_profile/renter_profile.dart';
import 'package:xplorit/features/lent/lender_profile/lender_profile_aboutus.dart';
import 'package:xplorit/features/product/product_list.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class RenterProfileHomePage extends StatefulWidget {
  const RenterProfileHomePage({super.key});

  @override
  State<RenterProfileHomePage> createState() => _RenterProfileHomePageState();
}

class _RenterProfileHomePageState extends State<RenterProfileHomePage> {
  bool isSwitched = false;
  final isLoading = false.obs;
  bool isLender = false;
  String userPhoneNumber = '';
  String userName = '';
  String renterId = '';
  bool isRentedAVehicle = false;
  int bottomNavBarCurrentIndex = 4;
  String profilePicture = TImages.profile;
  User? user = FirebaseAuth.instance.currentUser;
  final renterController = Get.put(RenterController());
  final garageController = Get.put(GarageController());
  final AuthController authController = AuthController();
  bool hasUnreadMessages = false;

  final vehicleController = Get.put(VehicleController());
  final rentedVehicleController = Get.put(RentedVehicleController());
  final bookingController = Get.put(BookingController());
  final completedRentController = Get.put(CompletedRentController());
  final cancelledBookingController = Get.put(CancelledBookingController());

  Future<void> fetchProfilePicture() async {
    await renterController.fetchRenterData();
    try {
      setState(() {
        for (RenterModel renter in renterController.rentersData) {
          if (renter.contactNumber == user?.phoneNumber) {
            try {
              profilePicture = renter.profilePicture;
              userName = renter.userName;
              renterId = renter.renterId;
              isRentedAVehicle = renter.isRentedAVehicle;
            } catch (e) {
              userName = 'Your Profile';
              profilePicture = TImages.profile;
            }
          }
        }
      });
    } catch (e) {
      for (RenterModel renter in renterController.rentersData) {
        if (renter.contactNumber == user?.phoneNumber) {
          try {
            profilePicture = renter.profilePicture;
            userName = renter.userName;
            renterId = renter.renterId;
            isRentedAVehicle = renter.isRentedAVehicle;
          } catch (e) {
            userName = 'Your Profile';
            profilePicture = TImages.profile;
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await fetchProfilePicture();
    await fetchGarageData();
  }

  // Asynchronous method to fetch garage data
  Future<void> fetchGarageData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        userPhoneNumber = user.phoneNumber ?? '';
        for (GarageModel garage in garageController.garagesData) {
          if (userPhoneNumber == garage.contactNumber) {
            setState(() {
              isLender = true;
            });
          }
        }
      } catch (r) {}
    }
  }

  Future<bool> showConfirmation(context) async {
    return await showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing by tapping outside the dialog

        builder: (context) => AlertDialog(
              title: const Text(
                'No lender account exists for this phone number. Would you like to create a new lender account',
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
                              Get.to(() => signupwithphExistingUser(
                                  newUserType: 'lender',
                                  phoneNumber: userPhoneNumber));
                              Navigator.of(context).pop(false);
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
                'You are currently rented a vehicle.\nPlease ensure the vehicle is returned before deleting your account.',
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
    if (isRentedAVehicle) {
      Navigator.of(context).pop(false);
      showErrorDeleteAccount(context);
    } else {
      for (BookingModel booking in bookingController.bookingsData) {
        if (renterId == booking.renterId) {
          bookingController.removeBookingData(booking.bookingId);
        }
      }

      for (CompletedRentModel completedRent
          in completedRentController.completedRentsData) {
        if (renterId == completedRent.renterId) {
          completedRentController
              .removeCompletedRentData(completedRent.completedRentId);
        }
      }

      for (CancelledBookingModel cancelledBooking
          in cancelledBookingController.cancelledbookingsData) {
        if (renterId == cancelledBooking.renterId) {
          completedRentController
              .removeCompletedRentData(cancelledBooking.cancelledBookingId);
        }
      }
      renterController.removeRenterData(renterId);
      authController.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button from popping the current route
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
                Center(
                  child: Obx(
                    () {
                      return isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: TColors.primary,
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : Builder(builder: (context) {
                              // for (RenterModel renter
                              //     in renterController.rentersData) {
                              //   try {
                              //     isLoading.value = true;
                              //     if (renter.profilePicture.isNotEmpty) {
                              //       profilePicture = renter.profilePicture;
                              //     } else {
                              //       profilePicture = TImages.profile;
                              //     }
                              //   } finally {
                              //     isLoading.value = false;
                              //   }
                              // }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: profilePicture.startsWith('http')
                                    ? Image.network(
                                        profilePicture,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.person,
                                                    color: TColors.secondary,
                                                    size: 60),
                                                SizedBox(height: 4),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        profilePicture,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.error,
                                                    color: Colors.red,
                                                    size: 20),
                                                SizedBox(height: 4),
                                                Text('Image Not Found',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15)),
                                              ],
                                            ),
                                          );
                                        },
                                      ),

                                // Image.asset(
                                //   TImages.profile,
                                //   height: 80,
                                //   width: 80,
                                //   fit: BoxFit.cover,
                                // ),
                              );
                            });
                    },
                  ),
                ),
                // GestureDetector(
                //   // onTap: widget.tapCal,
                //   child: CircleAvatar(
                //     radius: 35,
                //     backgroundImage: AssetImage(TImages.profile),
                //   ),
                // ),
                SizedBox(height: 10),
                Text(userName.toUpperCase(),
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
                      RenterProfileCardWidget(
                          icon: Icons.person,
                          txt: 'Your Profile',
                          tapCal: () async {
                            setState(() {
                              Get.to(() => RenterProfile());
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      RenterProfileCardWidget(
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
                            'Change to Lender Mode',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'By activating this you will \n be redirected to your lend app',
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
                ElevatedBTN(
                  titleBtn: 'Sign Out',
                  onTapCall: () => {
                    authController.signOut(),
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedBTN(
                  titleBtn: 'Delete Account',
                  onTapCall: () => {
                    showDeleteAccountConfirmation(context),
                  },
                  btnColor: Colors.redAccent,
                ),
              ],
            ),
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
