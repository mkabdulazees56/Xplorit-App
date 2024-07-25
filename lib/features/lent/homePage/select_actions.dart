// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class SelectActions extends StatelessWidget {
  const SelectActions({
    required this.vehicleImg,
    required this.title,
    required this.tapCal,
    Key? key,
  }) : super(key: key);
  final String vehicleImg, title;
  final VoidCallback tapCal;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: TColors.greyMy,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: tapCal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(vehicleImg),
                  height: 60,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
