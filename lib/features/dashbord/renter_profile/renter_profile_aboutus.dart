// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(
                  btnColor: TColors.black,
                ),
              ),
              Text("About Us",
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  color: TColors.secondary, // Example background color
                  borderRadius:
                      BorderRadius.circular(12), // Example border radius
                ),
                padding: EdgeInsets.all(16), // Example padding
                child: Text(
                  "You will only get a refund of 50% subtotal and full payment of refundable deposit if you made payment online. You will only get a refund of 50% subtotal and full payment of refundable deposit if you made payment online.\n You will only get a refund of 50% subtotal and full payment of refundable deposit if you made payment online. You will only get a refund of 50% subtotal and full payment of refundable deposit if you made payment online.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
