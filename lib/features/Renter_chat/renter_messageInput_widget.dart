// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class RenterMessageInput extends StatelessWidget {
  final String hintText;
  final bool obscuretxt;
  final TextEditingController controller;

  const RenterMessageInput({
    Key? key,
    required this.hintText,
    required this.obscuretxt,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        obscureText: obscuretxt,
        controller: controller,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: TextStyle(
          color: TColors.blueLight, // Set your desired text color
          fontSize: 16.0, // Set your desired text size
        ),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(22.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(22.0),
          ),
          fillColor: TColors.greyLight,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: TColors.blueLight),
        ),
      ),
    );
  }
}
