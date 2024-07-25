// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class FeaturesWidget extends StatelessWidget {
  const FeaturesWidget({
    required this.title1,
    this.title2 = '',
    super.key,
  });

  final String title1, title2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: TColors.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title1,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  title2,
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
