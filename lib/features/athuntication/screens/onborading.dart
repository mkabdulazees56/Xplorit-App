// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/features/athuntication/screens/mode_selection.dart';
import 'package:xplorit/features/athuntication/screens/signupwithph.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class OnBoadingScreen extends StatefulWidget {
  const OnBoadingScreen({super.key});

  @override
  State<OnBoadingScreen> createState() => _OnBoadingScreenState();
}

class _OnBoadingScreenState extends State<OnBoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondary,
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            SizedBox(height: 200),
            Image(
              width: TSizes.logoHeight,
              height: TSizes.logoHeight,
              image: AssetImage(TImages.onBoardingImage1),
            ),
            Text('Rent With Ease',
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 250),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(SignupWithPh());
                },
                label: Text('Get Started'),
                icon: Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
