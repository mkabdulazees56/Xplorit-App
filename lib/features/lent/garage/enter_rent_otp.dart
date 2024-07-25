// // // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:pinput/pinput.dart';
// // // import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// // import 'package:xplorit/common_widgets/back_botton_widget.dart';
// // import 'package:xplorit/utils/constants/colors.dart';
// // import 'package:xplorit/utils/constants/image_strings.dart';
// // import 'package:xplorit/utils/constants/sizes.dart';

// // class EnterRentOtp extends StatefulWidget {
// //   final String renterId;
// //   // final String phoneNumber;
// //   // final String newUserType;

// //   const EnterRentOtp({
// //     super.key,
// //     required this.renterId,
// //     // required this.newUserType,
// //     // required this.phoneNumber
// //   });

// //   @override
// //   State<EnterRentOtp> createState() => _EnterOtpRentState();
// // }

// // class _EnterOtpRentState extends State<EnterRentOtp> {
// //   final TextEditingController _otpController = TextEditingController();
// //   // final FirebaseAuth auth = FirebaseAuth.instance;
// //   // final FirebaseFirestore _db = FirebaseFirestore.instance;
// //   final isLoading = false.obs;
// //   bool _isOtpValid = false;
// //   // final renterController = Get.put(RenterController());
// //   // final garageController = Get.put(GarageController());

// //   @override
// //   void initState() {
// //     super.initState();
// //     // _initializeData();
// //   }

// //   Future<void> _validateOtp() async {
// //     String enteredOtp = _otpController.text.trim();
// //     Get.snackbar('Error', _otpController.text.trim(),
// //         snackPosition: SnackPosition.TOP,
// //         colorText: Color.fromARGB(255, 255, 0, 0),
// //         duration: const Duration(seconds: 3),
// //         margin: const EdgeInsets.all(20),
// //         backgroundColor: Colors.white);
// //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
// //         .collection('otps')
// //         .doc(widget.renterId)
// //         .get();

// //     if (snapshot.exists) {
// //       var data = snapshot.data() as Map<String, dynamic>;
// //       String savedOtp = data['otp'];
// //       setState(() {
// //         _isOtpValid = enteredOtp == savedOtp;
// //       });

// //       if (_isOtpValid) {
// //         Get.snackbar('$savedOtp', '$enteredOtp');
// //         // Perform further actions
// //         ScaffoldMessenger.of(context)
// //             .showSnackBar(SnackBar(content: Text('OTP is valid!')));
// //       } else {
// //         Get.snackbar('$savedOtp', '$enteredOtp');

// //         ScaffoldMessenger.of(context)
// //             .showSnackBar(SnackBar(content: Text('Invalid OTP')));
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     var code = '';
// //     return SafeArea(
// //       child: Scaffold(
// //         body: Padding(
// //           padding: const EdgeInsets.all(TSizes.defaultSpace),
// //           child: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 BackButtonWidget(),
// //                 SizedBox(
// //                   height: 60,
// //                 ),
// //                 Row(
// //                   children: [
// //                     Image(
// //                       width: 55,
// //                       height: 55,
// //                       image: AssetImage(TImages.logo),
// //                     ),
// //                     Image(
// //                       width: 200,
// //                       height: 60,
// //                       image: AssetImage(TImages.title),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   height: 10,
// //                 ),
// //                 Text(
// //                   'Enter otp sent to the renter to confirm the vehicle submission',
// //                   style: Theme.of(context).textTheme.bodyLarge,
// //                 ),
// //                 SizedBox(
// //                   height: 60,
// //                 ),
// //                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //                   Text(
// //                     'Verify otp number.',
// //                     style: Theme.of(context).textTheme.headlineLarge,
// //                   ),
// //                   SizedBox(
// //                     height: 10,
// //                   ),
// //                 ]),
// //                 Pinput(
// //                   length: 6,
// //                   pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
// //                   showCursor: true,
// //                   onChanged: (value) {
// //                     code = value;
// //                     print(code);
// //                   },
// //                 ),
// //                 SizedBox(
// //                   height: 40,
// //                 ),
// //                 // TextButton(
// //                 //   onPressed: () {
// //                 //     setState(() {
// //                 //       // Get.to(SignupWithPh());
// //                 //     });
// //                 //   },
// //                 //   child: Text(
// //                 //     'Didn\'t get OTP Code?',
// //                 //     style: Theme.of(context).textTheme.titleMedium,
// //                 //   ),
// //                 // ),
// //                 SizedBox(
// //                   height: 10,
// //                 ),
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: Obx(
// //                     () {
// //                       return isLoading.value
// //                           ? Center(
// //                               child: CircularProgressIndicator(
// //                                 color: TColors.primary,
// //                                 backgroundColor: Colors.transparent,
// //                               ),
// //                             )
// //                           : ElevatedButton(
// //                               onPressed: () async {
// //                                 isLoading.value = true;
// //                                 try {
// //                                   Get.snackbar('Haha', 'Going into',
// //                                       snackPosition: SnackPosition.BOTTOM,
// //                                       colorText: Color.fromARGB(255, 255, 0, 0),
// //                                       duration: const Duration(seconds: 3),
// //                                       margin: const EdgeInsets.all(20),
// //                                       backgroundColor: Colors.white);
// //                                   await _validateOtp;
// //                                   Get.snackbar('Code', code,
// //                                       snackPosition: SnackPosition.BOTTOM,
// //                                       colorText: Color.fromARGB(255, 255, 0, 0),
// //                                       duration: const Duration(seconds: 3),
// //                                       margin: const EdgeInsets.all(20),
// //                                       backgroundColor: Colors.white);
// //                                 } catch (ex) {
// //                                   Get.snackbar('Error', 'Something went wrong',
// //                                       snackPosition: SnackPosition.BOTTOM,
// //                                       colorText: Color.fromARGB(255, 255, 0, 0),
// //                                       duration: const Duration(seconds: 3),
// //                                       margin: const EdgeInsets.all(20),
// //                                       backgroundColor: Colors.white);
// //                                   print("Wrong Otp");
// //                                 } finally {
// //                                   isLoading.value = false;
// //                                 }
// //                               },
// //                               child: Text(
// //                                 'Submit Code',
// //                               ),
// //                             );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
// import 'package:xplorit/Controllers/booking_controller.dart';
// import 'package:xplorit/Controllers/garage_controller.dart';
// import 'package:xplorit/Controllers/renter_controller.dart';
// import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
// import 'package:xplorit/Controllers/vehicle_controller.dart';
// import 'package:xplorit/Models/booking_model.dart';
// import 'package:xplorit/Models/rented_vehicle_model.dart';
// import 'package:xplorit/common_widgets/back_botton_widget.dart';
// import 'package:xplorit/utils/constants/colors.dart';
// import 'package:xplorit/utils/constants/image_strings.dart';
// import 'package:xplorit/utils/constants/sizes.dart';

// class EnterRentOtp extends StatefulWidget {
//   final String renterId;

//   const EnterRentOtp({
//     super.key,
//     required this.renterId,
//   });

//   @override
//   State<EnterRentOtp> createState() => _EnterOtpRentState();
// }

// class _EnterOtpRentState extends State<EnterRentOtp> {
//   final TextEditingController _otpController = TextEditingController();

//   final renterController = Get.put(RenterController());
//   final garageController = Get.put(GarageController());
//   final bookingController = Get.put(BookingController());
//   final vehicleController = Get.put(VehicleController());
//   final rentedVehicleController = Get.put(RentedVehicleController());
//   String vehicleId = '';
//   final isLoading = false.obs;
//   bool _isOtpValid = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<bool> _validateOtp() async {
//     String enteredOtp = _otpController.text.trim();
//     DocumentSnapshot snapshot = await FirebaseFirestore.instance
//         .collection('otps')
//         .doc(widget.renterId)
//         .get();

//     if (snapshot.exists) {
//       var data = snapshot.data() as Map<String, dynamic>;
//       String savedOtp = data['otp'];
//       setState(() {
//         _isOtpValid = enteredOtp == savedOtp;
//       });
//     }
//     return _isOtpValid;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 BackButtonWidget(),
//                 SizedBox(
//                   height: 60,
//                 ),
//                 Row(
//                   children: [
//                     Image(
//                       width: 55,
//                       height: 55,
//                       image: AssetImage(TImages.logo),
//                     ),
//                     Image(
//                       width: 200,
//                       height: 60,
//                       image: AssetImage(TImages.title),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Enter otp sent to the renter to confirm the vehicle submission',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 SizedBox(
//                   height: 60,
//                 ),
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   Text(
//                     'Verify otp number.',
//                     style: Theme.of(context).textTheme.headlineLarge,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                 ]),
//                 Pinput(
//                   length: 6,
//                   pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//                   showCursor: true,
//                   onChanged: (value) {
//                     print(value);
//                   },
//                   controller: _otpController,
//                 ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   child: Obx(
//                     () {
//                       return isLoading.value
//                           ? Center(
//                               child: CircularProgressIndicator(
//                                 color: TColors.primary,
//                                 backgroundColor: Colors.transparent,
//                               ),
//                             )
//                           : ElevatedButton(
//                               onPressed: () async {
//                                 isLoading.value = true;
//                                 try {
//                                   _isOtpValid = await _validateOtp();

//                                   if (_isOtpValid) {
//                                     for (RentedVehicleModel rentedVehicle
//                                         in rentedVehicleController
//                                             .rentedvehiclesData) {
//                                       if (widget.renterId ==
//                                           rentedVehicle.renterId) {
//                                         vehicleId = rentedVehicle.vehicleId;
//                                         rentedVehicleController
//                                             .removeRentedVehicleData(
//                                                 rentedVehicle.rentId);
//                                       }
//                                     }
//                                     for (BookingModel booking
//                                         in bookingController.bookingsData) {
//                                       if (widget.renterId == booking.renterId) {
//                                         bookingController.removeBookingData(
//                                             booking.bookingId);
//                                       }
//                                     }

//                                     vehicleController.updateVehicleActiveStatus(
//                                         vehicleId, true);
//                                     renterController.updateRenterActiveStatus(
//                                         widget.renterId, false);

//                                     await FirebaseFirestore.instance
//                                         .collection('otps')
//                                         .doc(widget.renterId)
//                                         .delete();

//                                     // Get.snackbar(
//                                     //     'OTP Valid', 'OTP entered is valid!',
//                                     //     snackPosition: SnackPosition.BOTTOM,
//                                     //     colorText:
//                                     //         Color.fromARGB(255, 0, 255, 0),
//                                     //     duration: const Duration(seconds: 3),
//                                     //     margin: const EdgeInsets.all(20),
//                                     //     backgroundColor: Colors.white);
//                                   } else {
//                                     Get.snackbar('Invalid OTP',
//                                         'The entered OTP is incorrect',
//                                         snackPosition: SnackPosition.BOTTOM,
//                                         colorText:
//                                             Color.fromARGB(255, 255, 0, 0),
//                                         duration: const Duration(seconds: 3),
//                                         margin: const EdgeInsets.all(20),
//                                         backgroundColor: Colors.white);
//                                   }
//                                 } catch (ex) {
//                                   Get.snackbar('Error', 'Something went wrong',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                       colorText: Color.fromARGB(255, 255, 0, 0),
//                                       duration: const Duration(seconds: 3),
//                                       margin: const EdgeInsets.all(20),
//                                       backgroundColor: Colors.white);
//                                 } finally {
//                                   isLoading.value = false;
//                                 }
//                               },
//                               child: Text(
//                                 'Submit Code',
//                               ),
//                             );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
