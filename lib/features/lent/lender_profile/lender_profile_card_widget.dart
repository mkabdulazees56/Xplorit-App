// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class LenderProfileCardWidget extends StatelessWidget {
  const LenderProfileCardWidget({
    required this.icon,
    required this.txt,
    required this.tapCal,
    this.colorIcon = TColors.primary,
    Key? key,
  }) : super(key: key);

  final String txt;
  final IconData icon;
  final Color colorIcon;
  final VoidCallback tapCal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapCal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 30,
                color: colorIcon,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                txt,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 24, color: Colors.grey),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 30,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
