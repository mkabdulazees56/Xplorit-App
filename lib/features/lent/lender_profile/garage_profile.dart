// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
// import 'package:xplorit/features/lent/AddGarage/text_input_widget.dart';
import 'package:xplorit/features/lent/AddVehicle/text_input_widget.dart';
import 'package:xplorit/features/lent/lender_profile/edit_garage_profile.dart';
import 'package:xplorit/features/lent/lender_profile/garage_address%20.dart';
import 'package:xplorit/features/lent/lender_profile/lender_profile_card_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class GarageProfile extends StatefulWidget {
  GarageProfile({this.mode = '', super.key});

  String mode;
  @override
  State<GarageProfile> createState() => _GarageProfileState();
}

class _GarageProfileState extends State<GarageProfile> {
  String? garageName = 'Enter garage name';
  String? phoneNumber;
  User? user = FirebaseAuth.instance.currentUser;
  final controller = Get.put(GarageController());

  @override
  void initState() {
    super.initState();
    fetchRenterData();
  }

  Future<void> fetchRenterData() async {
    // await controller.fetchGarageData();
    setState(() {
      for (GarageModel garage in controller.garagesData) {
        if (garage.contactNumber == user?.phoneNumber) {
          garageName = garage.userName;
        }
      }
    });
  }

  Future<List<Widget>> _buildGarageWidgets() async {
    List<Widget> garageWidgets = [];

    garageWidgets.add(
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
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
                  Get.to(() => EditGarageProfile());
                },
                color: TColors.primary,
                icon: Icon(
                  Icons.edit,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Image.asset(
            TImages.garageIcon,
            scale: 5,
          ),
          SizedBox(height: 10),
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
                InputTextWidget(
                  titleText: "Garage Name",
                  hintText: garageName!,
                  onChanged: (value) {
                    garageName = value;
                  },
                  enabled: false,
                ),
                InputTextWidget(
                  titleText: "Phone Number",
                  hintText: user!.phoneNumber.toString(),
                  onChanged: (value) {
                    phoneNumber = user?.phoneNumber;
                  },
                  enabled: false,
                ),
                SizedBox(
                  height: 20,
                ),
                LenderProfileCardWidget(
                  icon: Icons.location_on,
                  txt: 'See Garage Address',
                  tapCal: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GarageAddress(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return garageWidgets;
  }

  Widget garageForm() {
    return FutureBuilder<List<Widget>>(
      future: _buildGarageWidgets(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Disable resizing to avoid bottom overflow
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              garageForm(),
              SizedBox(height: 160),
              // ElevatedBTN(
              //   titleBtn: 'Save Changes',
              //   onTapCall: () => {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) =>
              //               GarageSetAddress(garageName: garageName!)),
              //     )
              //   },
              // ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
