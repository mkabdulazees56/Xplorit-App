// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120, 
        child: const Divider(
          color: TColors.black,
          thickness: 3,
          height: 40,
        ),
      ),
    );
  }
}
