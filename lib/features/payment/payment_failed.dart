// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/alert_icon_text.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/order_summery_widget.dart';

class PaymentFailed extends StatefulWidget {
  const PaymentFailed({Key? key}) : super(key: key);
  @override
  State<PaymentFailed> createState() => _SignUp();
}

class _SignUp extends State<PaymentFailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    AlertIconText(
                        alertText: 'Payment Failed',
                        alertIcon: Icons.close,
                        bgColor: Colors.red),
                    const SizedBox(height: 25),
                    Text(
                      'Payment Failed! Please try again',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    OrderSummery(
                      rentalRateType: 'Per day',
                      noOfDays: 5,
                      rentalRate: 1000,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedBTN(titleBtn: "Try Again", onTapCall: () {})
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
