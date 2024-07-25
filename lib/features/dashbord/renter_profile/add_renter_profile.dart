// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/lent/AddVehicle/text_input_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class AddRenterProfile extends StatefulWidget {
  AddRenterProfile({super.key});

  @override
  State<AddRenterProfile> createState() => _AddRenterProfileState();
}

class _AddRenterProfileState extends State<AddRenterProfile> {
  String renterName = 'Enter your name';
  String? renterId;
  bool isRentedAVehicle = false;
  String? phoneNumber;
  double longitude = 0.0;
  double latitude = 0.0;
  User? user = FirebaseAuth.instance.currentUser;
  XFile? profilePicture;
  String profilePictureUrl = TImages.profile;
  final isLoading = false.obs;
  final isSaveLoading = false.obs;
  final imageLoading = false.obs;
  final renterController = Get.put(RenterController());
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await checkUser();
  }

// Asynchronous method to fetch user data
  Future<void> checkUser() async {
    for (RenterModel renter in renterController.rentersData) {
      if (user?.phoneNumber == renter.contactNumber) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (Route<dynamic> route) => false,
        );
        // Get.to(() => const Dashboard());
      }
    }
  }

  Future<List<Widget>> _buildRenterWidgets() async {
    List<Widget> renterWidgets = [];
    try {
      renterWidgets.add(
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: BackButtonWidget(
                    btnColor: TColors.black,
                  ),
                ),
                Text(
                  "My Profile",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 70),
            Center(
              child: Column(
                children: [
                  Obx(() {
                    return imageLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : profilePictureUrl.startsWith('http')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  profilePictureUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error,
                                              color: Colors.red, size: 20),
                                          SizedBox(height: 4),
                                          Text('http Image Not Found',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : profilePictureUrl.startsWith('/data')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(profilePictureUrl),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error,
                                                  color: Colors.red, size: 20),
                                              SizedBox(height: 4),
                                              Text('http Image Not Found',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : profilePictureUrl.startsWith('TImages')
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                          profilePictureUrl,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.error,
                                                      color: Colors.red,
                                                      size: 20),
                                                  SizedBox(height: 4),
                                                  Text('Asset Image Not Found',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15)),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                          profilePictureUrl,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.person,
                                                      color: TColors.primary,
                                                      size: 60),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                  }),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Obx(
                      () {
                        return isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: TColors.secondary,
                                      foregroundColor: TColors.primary),
                                  child: const Text('Change profile picture'),
                                  onPressed: () async {
                                    isLoading.value = true;
                                    try {
                                      profilePicture = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                    } finally {
                                      isLoading.value = false;
                                    }
                                    setState(() {
                                      profilePictureUrl =
                                          profilePicture?.path ??
                                              TImages.profile;
                                    });
                                  },
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Renter Name',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 5),
                  TextField(
                    enabled: true,
                    controller: controller,
                    onChanged: (value) {
                      renterName = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: TColors.secondary,
                      hintText: renterName,
                      contentPadding: EdgeInsets.all(12),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  InputTextWidget(
                    titleText: "Phone Number",
                    hintText: user!.phoneNumber.toString(),
                    onChanged: (value) {
                      phoneNumber = user?.phoneNumber;
                    },
                    enabled: false,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error fetching renter data: $e');
    }

    return renterWidgets;
  }

  Widget renterForm() {
    return FutureBuilder<List<Widget>>(
      future: _buildRenterWidgets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data!,
          );
        }
      },
    );
  }

  void addRenterData(String profilePictureUrl, String renterName,
      double longitude, double latitude) {
    final renter = RenterModel(
      renterId: 'r1',
      userName: renterName,
      profilePicture: profilePictureUrl,
      contactNumber: user?.phoneNumber ?? '',
      latitude: latitude,
      longitude: longitude,
      isRentedAVehicle: isRentedAVehicle,
      timestamp: Timestamp.now(),
      noOfRating: 0,
      rating: 0.0,
    );

    renterController.addRenterData(renter);
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
    // else {
    //   getCurrentLocation();
    // }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _requestLocationPermission();
        });
      } else {
        getCurrentLocation();
      }
    } else {
      getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              renterForm(),
              Expanded(child: SizedBox()),
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () {
                    return isSaveLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              isSaveLoading.value = true;
                              try {
                                profilePictureUrl = await renterController
                                    .uploadProfilePicture(profilePicture);
                                isSaveLoading.value = true;

                                addRenterData(profilePictureUrl, renterName,
                                    longitude, latitude);
                              } catch (e) {
                                Get.snackbar('Oops!', e.toString());
                              } finally {
                                isSaveLoading.value = false;
                              }
                            },
                            child: const Text('Save Changes'),
                          );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:xplorit/Controllers/renter_controller.dart';
// import 'package:xplorit/Models/renter_model.dart';
// import 'package:xplorit/common_widgets/back_botton_widget.dart';
// import 'package:xplorit/features/lent/AddVehicle/text_input_widget.dart';
// import 'package:xplorit/utils/constants/colors.dart';
// import 'package:xplorit/utils/constants/image_strings.dart';

// class AddRenterProfile extends StatefulWidget {
//   AddRenterProfile({this.mode = '', super.key});

//   String mode;
//   @override
//   State<AddRenterProfile> createState() => _AddRenterProfileState();
// }

// class _AddRenterProfileState extends State<AddRenterProfile> {
//   // int count = 0;
//   bool isSwitched = false;
//   bool inEditMode = false;
//   bool isEditButtonActive = false;
//   String renterName = 'Enter your name';
//   String? renterId;
//   String? phoneNumber;
//   User? user = FirebaseAuth.instance.currentUser;
//   XFile? profilePicture;
//   String profilePictureUrl = TImages.profile;
//   final isLoading = false.obs;
//   final isSaveLoading = false.obs;
//   final renterController = Get.put(RenterController());
//   final TextEditingController controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     isEditButtonActive = false;
//     inEditMode = false;
//   }

//   Future<List<Widget>> _buildRenterWidgets() async {
//     List<Widget> renterWidgets = [];
//     Get.snackbar('Eidt mode', isEditButtonActive.toString());

//     try {
//       for (RenterModel renter in renterController.rentersData) {
//         // if (renter.contactNumber == user?.phoneNumber) {
//         //   renterName = renter.userName;
//         //   break;
//         // }

//         if (widget.mode != 'edit') {
//           if (renter.contactNumber == user?.phoneNumber) {
//             Get.snackbar('Contact Number',
//                 '${renter.contactNumber}, ${renter.userName}');
//             isEditButtonActive = true;
//             inEditMode = false;
//             try {
//               if (renter.profilePicture.isNotEmpty &&
//                   renter.profilePicture != '') {
//                 profilePictureUrl = renter.profilePicture;
//               } else {
//                 profilePictureUrl = TImages.profile;
//               }
//             } catch (e) {
//               Get.snackbar('Oops', e.toString());
//             }
//             renterName = renter.userName;
//           } else {
//             Get.snackbar('Contact Number',
//                 '${renter.contactNumber}, ${renter.userName}');
//             isEditButtonActive = false;
//             inEditMode = false;
//             renterName = 'Enter your name';
//           }
//           // break;
//         } else if (widget.mode == 'edit') {
//           inEditMode = true;

//           isEditButtonActive = false;
//           Get.snackbar('Contact Number', 'gg, ${renter.userName}');
//           try {
//             if (renter.profilePicture.isNotEmpty &&
//                 renter.profilePicture != '') {
//               profilePictureUrl = renter.profilePicture;
//             } else {
//               profilePictureUrl = TImages.profile;
//             }
//           } catch (e) {
//             Get.snackbar('Oops', e.toString());
//           }
//           // profilePictureUrl = renter.profilePicture;
//           renterName = renterName;
//           renterId = renter.renterId;
//         }
//       }

//       renterWidgets.add(
//         Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: BackButtonWidget(
//                     btnColor: TColors.black,
//                   ),
//                 ),
//                 Text(
//                   "My Profile",
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//                 Visibility(
//                   visible: isEditButtonActive,
//                   child: IconButton(
//                     onPressed: () {
//                       Get.to(() => AddRenterProfile(mode: 'edit'));
//                     },
//                     color: TColors.primary,
//                     icon: Icon(
//                       Icons.edit,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             // ProfilePicture(
//             //   isEditButtonActive: isEditButtonActive,
//             //   isLoading: isLoading,
//             // ),
//             Center(
//               child: Stack(
//                 children: [
//                   profilePicture == null
//                       ? ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: Image.asset(
//                             TImages.profile,
//                             height: 80,
//                             width: 80,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: Image.file(
//                             File(profilePicture!.path),
//                             height: 80,
//                             width: 80,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                   Visibility(
//                     visible: !isEditButtonActive,
//                     child: Positioned(
//                       top: 35,
//                       left: 35,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                         child: Obx(
//                           () {
//                             return isLoading.value
//                                 ? Center(child: CircularProgressIndicator())
//                                 : Padding(
//                                     padding:
//                                         const EdgeInsets.only(bottom: 15.0),
//                                     child: IconButton(
//                                       icon: Icon(
//                                         Icons.add_circle,
//                                         color: TColors.primary,
//                                         size: 40,
//                                       ),
//                                       onPressed: () async {
//                                         isLoading.value = true;
//                                         try {
//                                           profilePicture = await ImagePicker()
//                                               .pickImage(
//                                                   source: ImageSource.gallery);
//                                         } finally {
//                                           isLoading.value = false;
//                                         }
//                                         setState(() {
//                                           try {
//                                             if (profilePicture!.path != null &&
//                                                 profilePicture!
//                                                     .path.isNotEmpty) {
//                                               profilePictureUrl =
//                                                   profilePicture!.path;
//                                             } else {
//                                               profilePictureUrl =
//                                                   TImages.profile;
//                                             }
//                                           } catch (e) {
//                                             Get.snackbar('Oops!', e.toString());
//                                           }
//                                         });
//                                       },
//                                     ),
//                                   );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Image.asset(
//             //   TImages.renterIcon,
//             //   scale: 5,
//             // ),
//             SizedBox(height: 10),
//             SizedBox(
//               height: 40,
//             ),
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: Colors.grey,
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Renter Name',
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   TextField(
//                     enabled: !isEditButtonActive,
//                     controller: controller,
//                     onChanged: (value) {
//                       renterName = value;
//                     },
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: TColors.secondary,
//                       hintText: renterName,
//                       contentPadding: EdgeInsets.all(12),
//                     ),
//                     textAlignVertical: TextAlignVertical.center,
//                     textAlign: TextAlign.left,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   // InputTextWidget(
//                   //   titleText: "Renter Name",
//                   //   hintText: renterName,
//                   //   onChanged: (value) {
//                   //     renterName = value;
//                   //   },
//                   //   enabled: !isEditButtonActive,
//                   // ),
//                   InputTextWidget(
//                     titleText: "Phone Number",
//                     hintText: user!.phoneNumber.toString(),
//                     onChanged: (value) {
//                       phoneNumber = user?.phoneNumber;
//                     },
//                     enabled: false,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   // AddRenterProfileCardWidget(
//                   //   icon: Icons.location_on,
//                   //   txt: 'Set Address',
//                   //   tapCal: () {
//                   //     // Navigator.push(
//                   //     //   context,
//                   //     // MaterialPageRoute(
//                   //     // builder: (context) => RenterSetAddress(
//                   //     //   mode: '',
//                   //     //   renterName: renterName!,
//                   //     // ),
//                   //     // ),
//                   //     // );
//                   //   },
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print('Error fetching renter data: $e');
//       // Handle error as required
//     }

//     return renterWidgets;
//   }

//   Widget renterForm() {
//     return FutureBuilder<List<Widget>>(
//       future: _buildRenterWidgets(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: snapshot.data!,
//           );
//         }
//       },
//     );
//   }

//   void addRenterData(String profilePictureUrl, String renterName) {
//     final renter = RenterModel(
//       renterId: 'r1',
//       userName: renterName,
//       profilePicture: profilePictureUrl,
//       contactNumber: user?.phoneNumber ?? '',
//     );

//     RenterController.instance.addRenterData(renter);
//   }

//   void updateGarageData(
//       String documentId, String renterName, String profilePictureUrl) {
//     final renter = RenterModel(
//       renterId: documentId,
//       userName: renterName,
//       profilePicture: profilePictureUrl,
//       contactNumber: user?.phoneNumber ?? '',
//     );
//     RenterController.instance.updateRenterData(documentId, renter);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset:
//           false, // Disable resizing to avoid bottom overflow
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             children: [
//               renterForm(),
//               Expanded(child: SizedBox()),
//               Visibility(
//                 visible: !isEditButtonActive,
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Obx(
//                     () {
//                       return isSaveLoading.value
//                           ? Center(child: CircularProgressIndicator())
//                           : ElevatedButton(
//                               onPressed: () async {
//                                 if (!isEditButtonActive && inEditMode) {
//                                   try {
//                                     isSaveLoading.value = true;
//                                     profilePictureUrl = await renterController
//                                         .uploadProfilePicture(profilePicture);
//                                     updateGarageData(renterId!, renterName,
//                                         profilePictureUrl);
//                                   } catch (e) {
//                                     Get.snackbar('Oops!', e.toString());
//                                   } finally {
//                                     isSaveLoading.value = false;
//                                   }
//                                 } else if (!isEditButtonActive && !inEditMode) {
//                                   isSaveLoading.value = true;
//                                   try {
//                                     profilePictureUrl = await renterController
//                                         .uploadProfilePicture(profilePicture);
//                                     // Get.snackbar('Details',
//                                     //     '$renterName, ${user?.phoneNumber}, $profilePictureUrl',
//                                     //     duration: Duration(seconds: 5));
//                                     addRenterData(
//                                         profilePictureUrl, renterName);
//                                   } catch (e) {
//                                     Get.snackbar('Oops profile!', e.toString());
//                                   } finally {
//                                     isSaveLoading.value = false;
//                                   }
//                                 }
//                               },
//                               child: Text('Save Changes'),
//                             );
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class ProfilePicture extends StatefulWidget {
// //   final bool isEditButtonActive;
// //   final RxBool isLoading;

// //   ProfilePicture({required this.isEditButtonActive, required this.isLoading});

// //   @override
// //   _ProfilePictureState createState() => _ProfilePictureState();
// // }

// // class _ProfilePictureState extends State<ProfilePicture> {
// //   XFile? profilePicture;
// //   String profilePictureUrl = TImages.profile; // Placeholder

// //   Future<void> _pickImage() async {
// //     widget.isLoading.value = true;
// //     try {
// //       profilePicture =
// //           await ImagePicker().pickImage(source: ImageSource.gallery);
// //     } finally {
// //       widget.isLoading.value = false;
// //     }
// //     setState(() {
// //       try {
// //         if (profilePicture != null && profilePicture!.path.isNotEmpty) {
// //           profilePictureUrl = profilePicture!.path;
// //         } else {
// //           profilePictureUrl = TImages.profile;
// //         }
// //       } catch (e) {
// //         Get.snackbar('Oops!', e.toString());
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Stack(
// //         children: [
// //           profilePicture == null
// //               ? ClipRRect(
// //                   borderRadius: BorderRadius.circular(100),
// //                   child: Image.asset(
// //                     TImages.profile, // Replace with your placeholder asset
// //                     height: 80,
// //                     width: 80,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 )
// //               : ClipRRect(
// //                   borderRadius: BorderRadius.circular(100),
// //                   child: Image.file(
// //                     File(profilePicture!.path),
// //                     height: 80,
// //                     width: 80,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //           Visibility(
// //             visible: !widget.isEditButtonActive,
// //             child: Positioned(
// //               top: 35,
// //               left: 35,
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(100),
// //                 ),
// //                 child: Obx(
// //                   () {
// //                     return widget.isLoading.value
// //                         ? Center(child: CircularProgressIndicator())
// //                         : Padding(
// //                             padding: const EdgeInsets.only(bottom: 15.0),
// //                             child: IconButton(
// //                               icon: Icon(
// //                                 Icons.add_circle,
// //                                 color:
// //                                     TColors.primary, // Replace with your color
// //                                 size: 40,
// //                               ),
// //                               onPressed: _pickImage,
// //                             ),
// //                           );
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
