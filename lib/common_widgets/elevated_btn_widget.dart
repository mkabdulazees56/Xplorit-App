// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class ElevatedBTN extends StatelessWidget {
  const ElevatedBTN({
    required this.titleBtn,
    required this.onTapCall,
    this.btnColor = TColors.primary,
    this.textColor = TColors.white,
    Key? key,
  }) : super(key: key);

  final String titleBtn;
  final VoidCallback onTapCall;
  final Color btnColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTapCall,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
        ),
        child: Text(
          titleBtn,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
