// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/selection_mode_widget.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/dashbord/renter_profile/add_renter_profile.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/features/lent/lender_profile/add_garage_profile.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class ModeSelection extends StatefulWidget {
  const ModeSelection({
    required this.userStatus,
    Key? key,
  }) : super(key: key);

  final bool userStatus;

  @override
  State<ModeSelection> createState() => _ModeSelectionState();
}

class _ModeSelectionState extends State<ModeSelection> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _requestLocationPermission();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Navigation Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      'Select the Mode',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    // Category Description
                    const Text(
                      'Select the Category: Lender, Renter',
                      style: TextStyle(color: TColors.accent),
                    ),
                    const SizedBox(height: 30),
                    // Elevated Button for Renting
                    SelectionMode(
                      title: "Rent",
                      txt1: "Looking for a ride?\nBrowse available rentals.",
                      txt2: "Choose a vehicle to rent\nfor your journey.",
                      iconImg: TImages.renter,
                      bgcolor: TColors.blueLight,
                      onTapCall: () {
                        if (widget.userStatus) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()),
                            (Route<dynamic> route) => false,
                          );
                          // Get.to(Dashboard());
                        } else {
                          Get.to(AddRenterProfile());
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SelectionMode(
                      title: "Lend",
                      txt1:
                          "Have a vehicle to share?\nList it for others to rent.",
                      txt2: "Lend your vehicle and\nearn with us.",
                      iconImg: TImages.lenter,
                      bgcolor: TColors.lightRed,
                      onTapCall: () {
                        if (widget.userStatus) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomelentPage()),
                            (Route<dynamic> route) => false,
                          );
                          // Get.to(HomelentPage());
                        } else {
                          Get.to(AddGarageProfile());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
