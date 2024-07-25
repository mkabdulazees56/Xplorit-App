// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/alert_icon_text.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/order_summery_widget.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class LenderDeclined extends StatefulWidget {
  const LenderDeclined({Key? key}) : super(key: key);
  @override
  State<LenderDeclined> createState() => _SignUp();
}

class _SignUp extends State<LenderDeclined> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                Column(
                  children: [
                    AlertIconText(
                      alertText: 'Lender declined your request',
                      alertIcon: Icons.close,
                      bgColor: Colors.yellow,
                    ),
                    const SizedBox(height: 25),
                    OrderSummery(
                      rentalRateType: 'Per day',
                      noOfDays: 5,
                      rentalRate: 1000,
                    ),
                    SizedBox(height: 30),
                    ElevatedBTN(titleBtn: 'Back to home', onTapCall: () {})
                  ],
                ),
              ],
            ),
          ), //main Column
        ),
      ),
    );
  }
}
