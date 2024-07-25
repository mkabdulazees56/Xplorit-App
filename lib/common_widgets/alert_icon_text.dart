// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class AlertIconText extends StatelessWidget {
  const AlertIconText({
    required this.alertText,
    required this.alertIcon,
    required this.bgColor,
    super.key,
  });

  final String alertText;
  final IconData alertIcon;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 55,),
        CircleAvatar(
          radius: 40,
          backgroundColor: bgColor,
          child: Icon(
            alertIcon,
            color: TColors.white,
            size: 50,
          ),
        ),
        SizedBox(height: 15),
        Text(
          alertText,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
