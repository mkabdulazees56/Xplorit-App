// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class VehicleSelectFilter extends StatelessWidget {
  const VehicleSelectFilter({
    required this.vehicleImg,
    required this.title,
    required this.tapCal,
    super.key,
  });

  final String vehicleImg, title;
  final VoidCallback tapCal;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: TColors.secondary,
          borderRadius: BorderRadius.circular(12),
        ),

        height: 75,
        child: GestureDetector(
          onTap: tapCal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(vehicleImg),
                height: 40,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
