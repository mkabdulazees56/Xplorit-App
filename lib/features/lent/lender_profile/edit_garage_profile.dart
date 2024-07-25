// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
// import 'package:xplorit/features/lent/AddGarage/text_input_widget.dart';
import 'package:xplorit/features/lent/AddVehicle/text_input_widget.dart';
import 'package:xplorit/features/lent/lender_profile/edit_garage_address.dart';
import 'package:xplorit/features/lent/lender_profile/lender_profile_card_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class EditGarageProfile extends StatefulWidget {
  EditGarageProfile({super.key});

  @override
  State<EditGarageProfile> createState() => _EditGarageProfileState();
}

class _EditGarageProfileState extends State<EditGarageProfile> {
  String? garageName = 'Enter new garage name';
  String? phoneNumber;
  String? garageId;
  String? address;
  User? user = FirebaseAuth.instance.currentUser;
  final garageController = Get.put(GarageController());

  @override
  void initState() {
    super.initState();
    fetchGarageData();
  }

  Future<void> fetchGarageData() async {
    // await garageController.fetchGarageData();
    setState(() {
      for (GarageModel garage in garageController.garagesData) {
        if (garage.contactNumber == user?.phoneNumber) {
          garageName = garage.userName;
          garageId = garage.garageId;
          address = garage.address;
        }
      }
    });
  }

  void updateGarageData(String garageName, String address) {
    final garage = GarageModel(
      garageId: garageId!,
      userName: garageName,
      address: address,
      contactNumber: user?.phoneNumber,
    );
    GarageController.instance.updateGarageData(garageId!, garage);
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
                  enabled: true,
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
                  txt: 'Edit Address',
                  tapCal: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditGarageAddress(
                          garageAddress: address!,
                        ),
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
              Expanded(child: SizedBox()),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    updateGarageData(
                      garageName!,
                      address!,
                    );
                  },
                  child: Text('Save Changes'),
                ),
              ),
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
