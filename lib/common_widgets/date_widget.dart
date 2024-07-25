// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    required this.dateText,
    required this.dateFunc,
    required this.iconBook,
    super.key,
  });

  final String dateText, dateFunc;
  final IconData iconBook;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 80,
          width: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            color: TColors.primary,
          ),
          child: Icon(
            iconBook,
            color: TColors.white,
          ),
        ),
        Container(
          width: 125,
          height: 80,
          decoration: const BoxDecoration(
            color: TColors.blueLight,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                dateText,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.apply(color: TColors.black),
              ),
              Text(dateFunc),
            ],
          ),
        ),
      ],
    );
  }
}
