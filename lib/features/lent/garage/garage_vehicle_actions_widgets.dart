// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class VehicleActionsWidget extends StatelessWidget {
  const VehicleActionsWidget({
    required this.iconImg,
    required this.title,
    required this.tapCal,
    Key? key,
  }) : super(key: key);
  final String iconImg, title;
  final VoidCallback tapCal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: TColors.greyMy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: tapCal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: AssetImage(iconImg),
                height: 120,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge,
              )
            ],
          ),
        ),
      ),
    );
  }
}
