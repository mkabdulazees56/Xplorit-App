// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/alert_icon_text.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/order_summery_widget.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class OrderPlace extends StatefulWidget {
  const OrderPlace({Key? key}) : super(key: key);
  @override
  State<OrderPlace> createState() => _OrderPlace();
}

class _OrderPlace extends State<OrderPlace> {
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
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Card',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            TImages.visa,
                            scale: 2,
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            '**** ***** **** 2334',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '12,500 PKR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0E642A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
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
