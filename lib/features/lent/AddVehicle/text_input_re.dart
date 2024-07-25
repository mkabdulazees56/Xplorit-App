// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class InputTextWidgetRe extends StatefulWidget {
  const InputTextWidgetRe({
    required this.hintText,
    required this.keyboardType,
    required this.onChanged,
    required this.index,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final Function(String, int) onChanged;
  final int index;
  final TextInputType keyboardType;

  @override
  State<InputTextWidgetRe> createState() => _InputTextWidgetReState();
}

class _InputTextWidgetReState extends State<InputTextWidgetRe> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        TextField(
          keyboardType: widget.keyboardType,
          onChanged: (value) {
            // Pass both the value and index to the parent onChanged callback
            widget.onChanged(value, widget.index);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: TColors.secondary,
            hintText: widget.hintText,
            contentPadding: EdgeInsets.all(12),
          ),
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
