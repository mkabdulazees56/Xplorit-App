// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/renter_model.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/features/athuntication/screens/mode_selection.dart';
import 'package:xplorit/features/athuntication/screens/signupwithph.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/dashbord/renter_profile/add_renter_profile.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/features/lent/lender_profile/add_garage_profile.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class EnterOtp extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String newUserType;

  const EnterOtp(
      {super.key,
      required this.verificationId,
      required this.newUserType,
      required this.phoneNumber});

  @override
  State<EnterOtp> createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final isLoading = false.obs;

  bool isLender = false;
  bool isRenter = false;
  bool isBoth = false;
  bool isNone = false;

  final renterController = Get.put(RenterController());
  final garageController = Get.put(GarageController());

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await checkUserType();
  }

// Asynchronous method to fetch user data
  Future<void> checkUserType() async {
    if (widget.newUserType == '') {
      await renterController.fetchRenterData();
      await garageController.fetchGarageData();
      for (GarageModel lender in garageController.garagesData) {
        if (widget.phoneNumber == lender.contactNumber) {
          setState(() {
            isLender = true;
          });
        }
      }
      for (RenterModel renter in renterController.rentersData) {
        if (widget.phoneNumber == renter.contactNumber) {
          setState(() {
            isRenter = true;
          });
        }
      }
      if (isLender && isLender) {
        setState(() {
          isBoth = true;
        });
      } else if (!isLender && !isRenter) {
        setState(() {
          isNone = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var code = '';
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonWidget(),
                SizedBox(
                  height: 60,
                ),
                Row(
                  children: [
                    Image(
                      width: 55,
                      height: 55,
                      image: AssetImage(TImages.logo),
                    ),
                    Image(
                      width: 200,
                      height: 60,
                      image: AssetImage(TImages.title),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Hi! Welcome to Xplorit',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 60,
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Verify phone number.',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
                Pinput(
                  length: 6,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onChanged: (value) {
                    code = value;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Get.to(SignupWithPh());
                    });
                  },
                  child: Text(
                    'Didn\'t get OTP Code?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () {
                      return isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: TColors.primary,
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                isLoading.value = true;
                                try {
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: widget.verificationId,
                                          smsCode: code);
                                  await auth.signInWithCredential(credential);
                                  Get.snackbar(
                                    'Succeccfull',
                                    'User Authenticated',
                                    snackPosition: SnackPosition.BOTTOM,
                                    colorText: Colors.green,
                                  );
                                  _db.collection('users').add({
                                    'phoneNo': widget.phoneNumber,
                                  }).catchError((error) {
                                    Get.snackbar(
                                      'Error',
                                      error.toString(),
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Color.fromARGB(255, 255, 0, 0),
                                    );
                                    print(error.toString());
                                  });

                                  if (widget.newUserType == '') {
                                    if (isRenter && !isLender) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard()),
                                        (Route<dynamic> route) => false,
                                      );
                                    } else if (!isRenter && isLender) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomelentPage()));
                                    } else if (isBoth) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ModeSelection(
                                                    userStatus: true,
                                                  )));
                                    } else if (isNone) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ModeSelection(
                                                    userStatus: false,
                                                  )));
                                    }
                                  } else {
                                    if (widget.newUserType == 'renter') {
                                      Get.to(AddRenterProfile());
                                    } else if (widget.newUserType == 'lender') {
                                      Get.to(AddGarageProfile());
                                    }
                                  }
                                } catch (ex) {
                                  Get.snackbar('Error', 'Invalid Otp',
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Color.fromARGB(255, 255, 0, 0),
                                      duration: const Duration(seconds: 3),
                                      margin: const EdgeInsets.all(20),
                                      backgroundColor: Colors.white);
                                  print("Wrong Otp");
                                } finally {
                                  isLoading.value = false;
                                }
                              },
                              child: Text(
                                'Submit Code',
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// // import 'package:flutter/material.dart';
// // import 'package:xplorit/features/athuntication/screens/mode_selection.dart';
// // import 'package:xplorit/utils/constants/sizes.dart';
// // import 'dart:async';

// // class EnterOtp extends StatefulWidget {
// //   const EnterOtp({Key? key}) : super(key: key);

// //   @override
// //   State<EnterOtp> createState() => _EnterOtpState();
// // }
// // class _EnterOtpState extends State<EnterOtp> {
// // //variables
// //   late Timer _timer;
// //   int timeLeft = 59; // Set your desired initial time

// //   @override
// //   void initState() {
// //     super.initState();
// //     startTimer();
// //   }

// //   void startTimer() {
// //     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
// //       if (timeLeft > 0) {
// //         setState(() {
// //           timeLeft--;
// //         });
// //       } else {
// //         timer.cancel();
// //         // Timer completed, handle accordingly
// //       }
// //     });
// //   }

// //   void resetTimer() {
// //     setState(() {
// //       timeLeft = 59;
// //     });
// //     startTimer();
// //   }

// //   @override
// //   void dispose() {
// //     _timer.cancel(); // Cancel the timer when the widget is disposed
// //     super.dispose();
// //   }

// //   TextEditingController txt1 = TextEditingController();
// //   TextEditingController txt2 = TextEditingController();
// //   TextEditingController txt3 = TextEditingController();
// //   TextEditingController txt4 = TextEditingController();

// //   bool invalidOtp = false;
// //   int resendTime = 0;
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         body: Padding(
// //           padding: const EdgeInsets.all(TSizes.defaultSpace),
// //           child: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 TextButton(
// //                   onPressed: () {
// //                      Navigator.pop(context);
// //                   },
// //                   child: Text(
// //                     '< Back',
// //                     style: Theme.of(context).textTheme.headlineSmall,
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: 60,
// //                 ),
// //                 Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       'Verify phone number.',
// //                       style: Theme.of(context).textTheme.headlineLarge,
// //                     ),
// //                     SizedBox(
// //                       height: 10,
// //                     ),
// //                     Text(
// //                       '00:' + timeLeft.toString().padLeft(2, '0'),
// //                       style: Theme.of(context).textTheme.headlineLarge,
// //                     ),
// //                     SizedBox(
// //                       height: 30,
// //                     ),
// //                     Text(
// //                       'Code has been sent to \n ******678',
// //                       style: Theme.of(context).textTheme.titleMedium,
// //                       textAlign: TextAlign.center,
// //                     ),
// //                     SizedBox(
// //                       height: 10,
// //                     ),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: [
// //                         myInputBox(context, txt1),
// //                         myInputBox(context, txt2),
// //                         myInputBox(context, txt3),
// //                         myInputBox(context, txt4),
// //                       ],
// //                     ),
// //                     SizedBox(
// //                       height: 30,
// //                     ),
// //                     Text(
// //                       invalidOtp ? 'Invalid OTP, Try Again' : "",
// //                       style: TextStyle(
// //                           fontFamily: 'Manrope',
// //                           fontSize: 18.0,
// //                           fontWeight: FontWeight.w500,
// //                           color: Colors.red),
// //                     ),
// //                     SizedBox(
// //                       height: 10,
// //                     ),
// //                     Text(
// //                       'Didn\'t get OTP Code?',
// //                       style: Theme.of(context).textTheme.titleMedium,
// //                     ),
// //                     SizedBox(
// //                       height: 10,
// //                     ),
// //                     timeLeft == 0
// //                         ? InkWell(
// //                             onTap: () {
// //                               resetTimer();
// //                             },
// //                             child: Text(
// //                               'Resent Code',
// //                               style: Theme.of(context).textTheme.titleMedium,
// //                             ),
// //                           )
// //                         : SizedBox(
// //                             height: 80,
// //                           ),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           final otp = txt1.text + txt3.text + txt3.text + txt4.text;
// //                           if (otp == '1998') {
// //                             setState(() {
// //                               invalidOtp = false;
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => ModeSelection(),
// //                                 ),
// //                               );
// //                             });
// //                           } else {
// //                             setState(() {
// //                               invalidOtp = true;
// //                             });
// //                           }
// //                         },
// //                         child: Text(
// //                           invalidOtp ? 'Try Again' : "Verify",
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // Widget myInputBox(BuildContext context, TextEditingController controller) {
// //   return Container(
// //     height: 60,
// //     width: 70,
// //     child: TextField(
// //       controller: controller,
// //       maxLength: 1,
// //       decoration: InputDecoration(
// //         counterText: '',
// //       ),
// //       textAlign: TextAlign.center,
// //       textAlignVertical: TextAlignVertical.center,
// //       keyboardType: TextInputType.number,
// //       style: Theme.of(context).textTheme.headlineLarge,
// //       onChanged: (value) => {
// //         if (value.length == 1) {FocusScope.of(context).nextFocus()}
// //       },
// //     ),
// //   );
// // }

// import 'package:flutter/material.dart';
// import 'package:xplorit/features/athuntication/controllers_onborading/auth_sevices.dart';
// import 'package:xplorit/features/athuntication/screens/enable_location.dart';
// import 'package:xplorit/utils/constants/sizes.dart';

// class EnterOtp extends StatefulWidget {
//   const EnterOtp({Key? key}) : super(key: key);

//   @override
//   State<EnterOtp> createState() => _EnterOtpState();
// }

// class _EnterOtpState extends State<EnterOtp> {
//   int timeLeft = 59;
//   late final String phoneNumber;
//   final TextEditingController otpController = TextEditingController();

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   // (this.phoneNumber);

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
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     '< Back',
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 60,
//                 ),
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   Text(
//                     'Verify phone number.',
//                     style: Theme.of(context).textTheme.headlineLarge,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     '00:' + timeLeft.toString().padLeft(2, '0'),
//                     style: Theme.of(context).textTheme.headlineLarge,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'Code has been sent to \n ******678',
//                     style: Theme.of(context).textTheme.titleMedium,
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),

//                   //       Pinput(
//                   //   length: 6,
//                   //   // defaultPinTheme: defaultPinTheme,
//                   //   // focusedPinTheme: focusedPinTheme,
//                   //   // submittedPinTheme: submittedPinTheme,

//                   //   showCursor: true,
//                   //   onCompleted: (pin) => print(pin),
//                 ]),
//                 Form(
//                   key: formKey,
//                   child: TextFormField(
//                     keyboardType: TextInputType.number,
//                     controller: otpController,
//                     decoration: InputDecoration(
//                       labelText: "Enter 6-digit OTP",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(32),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value!.length != 6) return "Invalid OTP";
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 Text(
//                   'Didn\'t get OTP Code?',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                   height: 80,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (formKey.currentState!.validate()) {
//                         AuthService.loginWithOtp(otp: otpController.text)
//                             .then((value) {
//                           if (value == "Success") {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => EnableLocation(),
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   value,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         });
//                       }
//                     },
//                     child: Text(
//                       'Send code',
//                     ),
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
