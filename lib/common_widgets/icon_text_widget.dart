// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    required this.icon,
    required this.txt,
    this.colorIcon = TColors.primary,
    super.key,
  });

  final String txt;
  final IconData icon;
  final Color colorIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorIcon,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis, // If text exceeds 2 lines, show ellipsis
          softWrap:
              true, // Wrap the text to the next line if it overflows the container width

          txt,
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ],
    );
  }
}
