// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class InputTextWidget extends StatefulWidget {
  InputTextWidget({
    required this.hintText,
    required this.onChanged,
    required this.enabled,
    this.titleText = "dfbn",
    Key? key,
  }) : super(key: key);

  final String hintText;
  final String titleText;
  final bool enabled;
  final Function(String) onChanged;

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.titleText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          enabled: widget.enabled,
          controller: controller,
          onChanged: widget.onChanged,
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
