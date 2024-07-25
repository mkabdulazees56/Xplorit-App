// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/alert_icon_text.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/order_summery_widget.dart';

class OrderPlaceCash extends StatefulWidget {
  const OrderPlaceCash({Key? key}) : super(key: key);
  @override
  State<OrderPlaceCash> createState() => _OrderPlace();
}

class _OrderPlace extends State<OrderPlaceCash> {
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
                const SizedBox(height: 10),
                const SizedBox(height: 25),
                Column(
                  children: [
                    AlertIconText(
                        alertText: "Order Placed Succesfully",
                        alertIcon: Icons.check,
                        bgColor: Colors.green),
                    const SizedBox(height: 15),
                    OrderSummery(
                      rentalRateType: 'Per day',
                      noOfDays: 5,
                      rentalRate: 1000,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Order placed succesfully, you can pay the total amount directly to lender thankyou ',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedBTN(
                  titleBtn: 'See My Booking',
                  onTapCall: () {},
                ),
                const SizedBox(height: 15),
                ElevatedBTN(
                  titleBtn: 'Back to Home',
                  onTapCall: () {},
                ),
                DividerWidget()
              ],
            ),
          ), //main Column
        ),
      ),
    );
  }
}
