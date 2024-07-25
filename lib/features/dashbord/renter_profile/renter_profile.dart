// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/features/dashbord/renter_profile/edit_renter_profile.dart';
import 'package:xplorit/features/lent/AddVehicle/text_input_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class RenterProfile extends StatefulWidget {
  RenterProfile({this.mode = '', super.key});

  String mode;
  @override
  State<RenterProfile> createState() => _RenterProfileState();
}

class _RenterProfileState extends State<RenterProfile> {
  String renterName = 'Enter your name';
  String? renterId;
  String? phoneNumber;
  XFile? profilePicture;
  final isLoading = false.obs;
  final imageLoading = false.obs;
  final isSaveLoading = false.obs;
  String profilePictureUrl = TImages.profile;
  User? user = FirebaseAuth.instance.currentUser;
  final renterController = Get.put(RenterController());
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRenterData();
  }

  Future<void> fetchRenterData() async {
    await renterController.fetchRenterData();
    setState(() {
      for (RenterModel renter in renterController.rentersData) {
        if (renter.contactNumber == user?.phoneNumber) {
          try {
            profilePictureUrl = renter.profilePicture;
          } catch (e) {
            Get.snackbar('Oops!', e.toString());
          }
          renterName = renter.userName;
        }
      }
    });
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
                IconButton(
                  onPressed: () {
                    Get.to(() => EditRenterProfile());
                  },
                  color: TColors.primary,
                  icon: const Icon(
                    Icons.edit,
                  ),
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
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: TColors.secondary,
                      hintText: renterName,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  InputTextWidget(
                    titleText: "Phone Number",
                    hintText: user!.phoneNumber.toString(),
                    onChanged: (value) {
                      phoneNumber = user?.phoneNumber;
                    },
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
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
          return const Center(child: CircularProgressIndicator());
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
            ],
          ),
        ),
      ),
    );
  }
}
