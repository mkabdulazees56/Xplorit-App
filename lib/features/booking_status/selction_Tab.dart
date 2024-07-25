// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class TSelcetionTab extends StatefulWidget {
  final Function onTap1;
  final Function onTap2;
  final Function onTap3;

  const TSelcetionTab({
    Key? key,
    required this.onTap1,
    required this.onTap2,
    required this.onTap3,
  }) : super(key: key);

  @override
  _TSelcetionTabState createState() => _TSelcetionTabState();
}

class _TSelcetionTabState extends State<TSelcetionTab> {
  int selectedButton = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                selectedButton = 0; // Change to 0 for the "Active" button
              });
              widget.onTap1();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                selectedButton == 0 ? TColors.primary : TColors.secondary,
              ),
              foregroundColor: MaterialStateProperty.all(
                selectedButton == 0 ? Colors.white : Colors.black,
              ),
            ),
            child: Text(
              "Active",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                selectedButton = 1;
              });
              widget.onTap2();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                selectedButton == 1 ? TColors.primary : TColors.secondary,
              ),
              foregroundColor: MaterialStateProperty.all(
                selectedButton == 1 ? TColors.white : Colors.black,
              ),
            ),
            child: Text(
              'Completed',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(width: 2),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                selectedButton = 2;
              });
              widget.onTap3();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                selectedButton == 2 ? TColors.primary : TColors.secondary,
              ),
              foregroundColor: MaterialStateProperty.all(
                selectedButton == 2 ? Colors.white : Colors.black,
              ),
            ),
            child: Text(
              "Cancelled",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
