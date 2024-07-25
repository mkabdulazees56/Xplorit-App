// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:xplorit/common_widgets/back_botton_widget.dart';
// import 'package:xplorit/features/athuntication/screens/enter_otp.dart';
// import 'package:xplorit/utils/constants/colors.dart';
// import 'package:xplorit/utils/constants/image_strings.dart';
// import 'package:xplorit/utils/constants/sizes.dart';

// class signupwithphExistingUser extends StatefulWidget {
//   const signupwithphExistingUser(
//       {required this.newUserType, required this.phoneNumber, Key? key})
//       : super(key: key);
//   static String verify = "";
//   final String newUserType;
//   final String phoneNumber;

//   @override
//   State<signupwithphExistingUser> createState() =>
//       _signupwithphExistingUserState();
// }

// class _signupwithphExistingUserState extends State<signupwithphExistingUser> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController codeController = TextEditingController();
//   String countryCode = '';
//   late String phoneNumber = ""; // Declare a variable to hold the phone number
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   String errorMsg = '';
//   final isLoading = false.obs;

//   static errorSnackBar({required title, message = ' '}) {
//     Get.snackbar(
//       title,
//       message,
//       isDismissible: true,
//       shouldIconPulse: true,
//       colorText: TColors.white,
//       backgroundColor: Colors.red.shade600,
//       snackPosition: SnackPosition.BOTTOM,
//       duration: const Duration(seconds: 3),
//       margin: const EdgeInsets.all(20),
//       icon: const Icon(Iconsax.warning_2, color: TColors.white),
//     );
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
//                   height: 30,
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
//                   'Hi! Welcome to Xplorit',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 Text(
//                   'Create your account.',
//                   style: Theme.of(context).textTheme.headlineLarge,
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Enter your phone number:',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InternationalPhoneNumberInput(
//                   onInputValidated: (bool value) {
//                     setState(() {
//                       if (!value) {
//                         if (phoneNumber != countryCode) {
//                           print('Country Code: $countryCode');
//                           print('Length: $value');
//                           errorMsg = '*Please enter a valid mobile number';
//                         } else if (phoneNumber == countryCode) {
//                           errorMsg = '';
//                         }
//                       } else if (value) {
//                         errorMsg = '';
//                       }
//                     });

//                     print('Length: $value');
//                   },
//                   //phoneNumbercontroller: phoneController,
//                   onInputChanged: (PhoneNumber number) {
//                     setState(() {
//                       countryCode = number.dialCode.toString();
//                       phoneNumber = number.phoneNumber.toString();
//                       print('Country Code: $countryCode');
//                     });
//                     print('Phone No.: $phoneNumber'); //whole number (+code)
//                   },

//                   selectorConfig: SelectorConfig(
//                     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                   ),
//                   ignoreBlank: false,
//                   // autoValidateMode: AutovalidateMode.disabled,
//                   selectorTextStyle: Theme.of(context).textTheme.titleMedium,
//                   formatInput: false,

//                   keyboardType: TextInputType.phone,
//                   cursorColor: Colors.black,
//                   inputDecoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(bottom: 15, left: 20),
//                     border: InputBorder.none,
//                     hintText: 'Phone Number',
//                     hintStyle: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 18,
//                     ),
//                   ),
//                   onSaved: (PhoneNumber number) {
//                     print('On Saved: $number');
//                   },
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Center(
//                   child: Text(
//                     errorMsg,
//                     style: TextStyle(color: Colors.red, fontSize: 15),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
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
//                                   if (phoneNumber == countryCode) {
//                                     // Show an error message if the phone number is empty
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(
//                                           'Please enter a phone number.',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               color: Colors.red,
//                                               backgroundColor:
//                                                   Colors.transparent),
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     try {
//                                       await FirebaseAuth.instance
//                                           .verifyPhoneNumber(
//                                         phoneNumber: phoneNumber,
//                                         timeout: Duration(seconds: 60),
//                                         verificationCompleted:
//                                             (PhoneAuthCredential credential) {
//                                           //handle
//                                         },
//                                         verificationFailed:
//                                             (FirebaseAuthException ex) {
//                                           //handle
//                                         },
//                                         codeSent: (String verificationId,
//                                             int? resendToken) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => EnterOtp(
//                                                     verificationId:
//                                                         verificationId,
//                                                     phoneNumber: phoneNumber)),
//                                           );
//                                         },
//                                         codeAutoRetrievalTimeout:
//                                             (String? verificationId) {
//                                           // errorSnackBar(
//                                           // title: 'Time out',
//                                           // message: 'Took long time');
//                                         },
//                                       );
//                                     } finally {}
//                                   }
//                                 } catch (e) {
//                                   Get.snackbar('Oops!', 'Something went wrong');
//                                 } finally {}
//                               },
//                               child: Text('Send OTP'),
//                             );
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Keep your mobile with you by clicking continue OTP will send to your above mentioned number for verification',
//                       style: Theme.of(context).textTheme.titleMedium,
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(
//                       height: 150,
//                     ),
//                     Text(
//                       "By signing up, you agree to Xplorit's\nTerms of Service and Privacy Policy.",
//                       style: Theme.of(context).textTheme.bodySmall,
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// // import 'package:flutter/material.dart';
// // import 'package:xplorit/common_widgets/back_botton_widget.dart';
// // import 'package:xplorit/features/athuntication/controllers_onborading/auth_sevices.dart';
// // import 'package:xplorit/features/athuntication/screens/enter_otp.dart';
// // import 'package:xplorit/utils/constants/image_strings.dart';
// // import 'package:xplorit/utils/constants/sizes.dart';

// // class SignupWithPh extends StatefulWidget {
// //   const SignupWithPh({Key? key}) : super(key: key);

// //   @override
// //   State<SignupWithPh> createState() => _SignupWithPhState();
// // }

// // class _SignupWithPhState extends State<SignupWithPh> {
// //   final TextEditingController phoneController = TextEditingController();

// //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
// //                 BackButtonWidget(),
// //                 SizedBox(
// //                   height: 30,
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
// //                   'Hi! Welcome to Xplorit',
// //                   style: Theme.of(context).textTheme.bodyLarge,
// //                 ),
// //                 SizedBox(
// //                   height: 40,
// //                 ),
// //                 Text(
// //                   'Create your account.',
// //                   style: Theme.of(context).textTheme.headlineLarge,
// //                 ),
// //                 SizedBox(
// //                   height: 10,
// //                 ),
// //                 Text(
// //                   'Enter your phone number:',
// //                   style: Theme.of(context).textTheme.titleMedium,
// //                 ),
// //                 SizedBox(
// //                   height: 10,
// //                 ),
// //                 // InternationalPhoneNumberInput(
// //                 //   controller: phoneController,
// //                 //   onInputChanged: (PhoneNumber number) {
// //                 //     print(number.phoneNumber);
// //                 //   },
// //                 //   onInputValidated: (bool value) {
// //                 //     print(value);
// //                 //   },
// //                 //   selectorConfig: SelectorConfig(
// //                 //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
// //                 //   ),
// //                 //   ignoreBlank: false,
// //                 //   autoValidateMode: AutovalidateMode.disabled,
// //                 //   selectorTextStyle: Theme.of(context).textTheme.titleMedium,
// //                 //   formatInput: false,
// //                 //   maxLength: 10,

// //                 //   keyboardType:
// //                 //       TextInputType.numberWithOptions(signed: true, decimal: true),
// //                 //   cursorColor: Colors.black,
// //                 //   inputDecoration: InputDecoration(
// //                 //     contentPadding: EdgeInsets.only(bottom: 15, left: 20),
// //                 //     border: InputBorder.none,
// //                 //     hintText: 'Phone Number',
// //                 //     hintStyle: TextStyle(
// //                 //       color: TColors.accent,
// //                 //       fontSize: 18,
// //                 //     ),
// //                 //   ),
// //                 //   onSaved: (PhoneNumber number) {
// //                 //     print('On Saved: $number');
// //                 //   },
// //                 // ),
// //                 Form(
// //                   key: formKey,
// //                   child: TextFormField(
// //                     controller: phoneController,
// //                     keyboardType: TextInputType.phone,
// //                     decoration: InputDecoration(
// //                       prefixText: "+91 ",
// //                       labelText: "Enter your phone number",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(32),
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value!.length != 10) return "Invalid phone number";
// //                       return null;
// //                     },
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: 20,
// //                 ),
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton(
// //                     // onPressed: () {
// //                     //   Navigator.push(
// //                     //     context,
// //                     //     MaterialPageRoute(
// //                     //       builder: (context) => EnterOtp(),
// //                     //     ),
// //                     //   );
// //                     // },

// //                     onPressed: () {
// //                       if (formKey.currentState!.validate()) {
// //                         AuthService.sentOtp(
// //                           phone: phoneController.text,
// //                           errorStep: () =>
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(
// //                               content: Text(
// //                                 "Error in sending OTP",
// //                                 style: TextStyle(color: Colors.white),
// //                               ),
// //                               backgroundColor: Colors.red,
// //                             ),
// //                           ),
// //                           nextStep: () {
// //                             Navigator.pushReplacement(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => EnterOtp(),
// //                               ),
// //                             );
// //                           },
// //                         );
// //                       }
// //                     },
// //                     child: Text('Send OTP'),
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: 50,
// //                 ),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       'Keep your mobile with you by clicking continue OTP will send to your above mentioned number for verification',
// //                       style: Theme.of(context).textTheme.titleMedium,
// //                       textAlign: TextAlign.center,
// //                     ),
// //                     SizedBox(
// //                       height: 150,
// //                     ),
// //                     Text(
// //                       "By signing up, you agree to Xplorit's\nTerms of Service and Privacy Policy.",
// //                       style: Theme.of(context).textTheme.bodySmall,
// //                       textAlign: TextAlign.center,
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
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/features/athuntication/screens/enter_otp.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class signupwithphExistingUser extends StatefulWidget {
  const signupwithphExistingUser(
      {required this.newUserType, required this.phoneNumber, Key? key})
      : super(key: key);
  static String verify = "";
  final String newUserType;
  final String phoneNumber;

  @override
  State<signupwithphExistingUser> createState() =>
      _signupwithphExistingUserState();
}

class _signupwithphExistingUserState extends State<signupwithphExistingUser> {
  final isLoading = false.obs;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber(widget.phoneNumber);
  }

  void _verifyPhoneNumber(String phoneNumber) async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-resolve logic if needed
        },
        verificationFailed: (FirebaseAuthException ex) {
          Get.snackbar('Oops!', ex.toString(),
              mainButton: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Navigate back
                    ;
                  },
                  child: Text('Ok')));
          setState(() {
            errorMsg = ex.message ?? 'Verification failed. Please try again.';
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isLoading.value = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EnterOtp(
                    newUserType: widget.newUserType,
                    verificationId: verificationId,
                    phoneNumber: phoneNumber)),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading.value = false;
          });
          // Optionally handle auto retrieval timeout
        },
      );
    } catch (e) {
      Get.snackbar('Oops!', 'Something went wrong');
      setState(() {
        isLoading.value = false;
      });
    }
  }

  static errorSnackBar({required title, message = ' '}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: TColors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  height: 30,
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
                  height: 40,
                ),
                Text(
                  'Create your ${widget.newUserType} account.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'We are verifying your phone number:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.phoneNumber,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: 5,
                ),
                if (errorMsg.isNotEmpty)
                  Center(
                    child: Text(
                      errorMsg,
                      style: TextStyle(color: Colors.red, fontSize: 15),
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
                          : Container(); // No button needed
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Keep your mobile with you. We are sending an OTP to your phone number for verification.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      "By signing up, you agree to Xplorit's\nTerms of Service and Privacy Policy.",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
