// // ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:xplorit/Controllers/booking_controller.dart';
// import 'package:xplorit/Controllers/cancel_booking_controller.dart';
// import 'package:xplorit/Controllers/garage_controller.dart';
// import 'package:xplorit/Controllers/renter_controller.dart';
// import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
// import 'package:xplorit/Controllers/vehicle_controller.dart';
// import 'package:xplorit/Models/garage_model.dart';
// import 'package:xplorit/Models/renter_model.dart';
// import 'package:xplorit/features/athuntication/controllers_onborading/auth_sevices.dart';
// import 'package:xplorit/features/athuntication/screens/mode_selection.dart';
// import 'package:xplorit/features/athuntication/screens/onborading.dart';
// import 'package:xplorit/features/dashbord/dashboard.dart';
// import 'package:xplorit/features/lent/homePage/home_lent.dart';
// import 'package:xplorit/utils/theme/theme.dart';

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.system,
//       theme: TAppTheme.lightTheme,
//       darkTheme: TAppTheme.lightTheme,
//       home: const CheckUserLoggedInOrNot(),
//     );
//   }
// }

// class CheckUserLoggedInOrNot extends StatefulWidget {
//   const CheckUserLoggedInOrNot({super.key});

//   @override
//   State<CheckUserLoggedInOrNot> createState() => _CheckUserLoggedInOrNotState();
// }

// class _CheckUserLoggedInOrNotState extends State<CheckUserLoggedInOrNot> {
//   bool isBoth = false;
//   bool isNone = false;
//   bool isLender = false;
//   bool isRenter = false;
//   final renterController = Get.put(RenterController());
//   final garageController = Get.put(GarageController());
//   final bookingController = Get.put(BookingController());
//   final vehicleController = Get.put(VehicleController());
//   final cancelledBookingController = Get.put(CancelledBookingController());
//   final rentedVehiclecontroller = Get.put(RentedVehicleController());

// // if(user?.phoneNumber == garage.garageId)
//   Future<void> _initializeData() async {
//     await fetchGarageData();
//     await fetchVehicleData();
//     await fetchRenterData();
//     await fetchBookingData();
//     await fetchRentedVehicleData();
//     await fetchcancelledBookingData();
//   }

// // Asynchronous method to fetch vehicle data
//   Future<void> fetchVehicleData() async {
//     await vehicleController.fetchVehicleData();
//   }

//   Future<void> fetchRenterData() async {
//     await renterController.fetchRenterData();
//   }

// // Asynchronous method to fetch vehicle data
//   Future<void> fetchBookingData() async {
//     await bookingController.fetchBookingData();
//   }

//   // Asynchronous method to fetch garage data
//   Future<void> fetchGarageData() async {
//     await garageController.fetchGarageData();
//   }

//   Future<void> fetchRentedVehicleData() async {
//     await rentedVehiclecontroller.fetchRentedVehicleData();
//   }

//   Future<void> fetchcancelledBookingData() async {
//     await cancelledBookingController.fetchCancelledBookingData();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     isBoth = false;
//     isNone = false;
//     isLender = false;
//     isRenter = false;

//     Future.delayed(Duration.zero, () {
//       AuthService.isLoggedIn().then((value) {
//         if (value) {
//           User? user = FirebaseAuth.instance.currentUser;

//           for (GarageModel lender in garageController.garagesData) {
//             if (user?.phoneNumber == lender.contactNumber) {
//               isLender = true;
//             }
//           }
//           for (RenterModel renter in renterController.rentersData) {
//             if (user?.phoneNumber == renter.contactNumber) {
//               isRenter = true;
//             }
//           }
//         } else {
//           isNone;
//         }
//       });
//       if (isRenter && !isLender) {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => Dashboard()));
//       } else if (!isRenter && isLender) {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => HomelentPage()));
//       } else if (isRenter && isLender) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ModeSelection(
//                       userStatus: true,
//                     )));
//       } else if (isNone) {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => OnBoadingScreen()));
//       }
//       // AuthService.isLoggedIn().then((value) {
//       //   if (value) {
//       //     Navigator.pushReplacement(
//       //       context,
//       //       // MaterialPageRoute(builder: (context) => EnableLocation()),
//       //       MaterialPageRoute(builder: (context) => Dashboard()),
//       //     );
//       //   } else {

//       //     Navigator.pushReplacement(
//       //       context,
//       //       MaterialPageRoute(builder: (context) => OnBoadingScreen()),
//       //     );
//       //   }
//       // });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/cancel_booking_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/features/athuntication/controllers_onborading/auth_sevices.dart';
import 'package:xplorit/features/athuntication/screens/mode_selection.dart';
import 'package:xplorit/features/athuntication/screens/onborading.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        '/onboarding': (context) =>
            OnBoadingScreen(), // Add the OnBoardingScreen route
        // Add other routes as needed
      },
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.lightTheme,
      home: const CheckUserLoggedInOrNot(),
    );
  }
}

class CheckUserLoggedInOrNot extends StatefulWidget {
  const CheckUserLoggedInOrNot({super.key});

  @override
  State<CheckUserLoggedInOrNot> createState() => _CheckUserLoggedInOrNotState();
}

class _CheckUserLoggedInOrNotState extends State<CheckUserLoggedInOrNot> {
  bool isBoth = false;
  bool isNone = false;
  bool isLender = false;
  bool isRenter = false;
  final renterController = Get.put(RenterController());
  final garageController = Get.put(GarageController());
  final bookingController = Get.put(BookingController());
  final vehicleController = Get.put(VehicleController());
  final cancelledBookingController = Get.put(CancelledBookingController());
  final rentedVehicleController = Get.put(RentedVehicleController());

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    await _initializeData();

    bool isLoggedIn = await AuthService.isLoggedIn();

    if (isLoggedIn) {
      User? user = FirebaseAuth.instance.currentUser;

      for (GarageModel lender in garageController.garagesData) {
        if (user?.phoneNumber == lender.contactNumber) {
          isLender = true;
        }
      }

      for (RenterModel renter in renterController.rentersData) {
        if (user?.phoneNumber == renter.contactNumber) {
          isRenter = true;
        }
      }

      if (isRenter && !isLender) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else if (!isRenter && isLender) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomelentPage()));
      } else if (isRenter && isLender) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ModeSelection(
                      userStatus: true,
                    )));
      } else {
        setState(() {
          isNone = true;
        });
      }
    } else {
      setState(() {
        isNone = true;
      });
    }

    if (isNone) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoadingScreen()));
    }
  }

  Future<void> _initializeData() async {
    await fetchGarageData();
    await fetchVehicleData();
    await fetchRenterData();
    await fetchBookingData();
    await fetchRentedVehicleData();
    await fetchCancelledBookingData();
    setState(() {
      isBoth = false;
      isNone = false;
      isLender = false;
      isRenter = false;
    });
  }

  Future<void> fetchVehicleData() async {
    await vehicleController.fetchVehicleData();
  }

  Future<void> fetchRenterData() async {
    await renterController.fetchRenterData();
  }

  Future<void> fetchBookingData() async {
    await bookingController.fetchBookingData();
  }

  Future<void> fetchGarageData() async {
    await garageController.fetchGarageData();
  }

  Future<void> fetchRentedVehicleData() async {
    await rentedVehicleController.fetchRentedVehicleData();
  }

  Future<void> fetchCancelledBookingData() async {
    await cancelledBookingController.fetchCancelledBookingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
