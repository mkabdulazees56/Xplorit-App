// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class YourVehicle extends StatefulWidget {
  const YourVehicle({
    required this.vehicleImg,
    required this.title,
    required this.tapCal,
    super.key,
  });

  final String vehicleImg, title;
  final VoidCallback tapCal;

  @override
  State<YourVehicle> createState() => _YourVehicleState();
}

class _YourVehicleState extends State<YourVehicle> {
  @override
  Widget build(BuildContext context) {
    return
        // Expanded(
        //   child:
        Row(
      children: [
        Container(
          width: 105,
          decoration: BoxDecoration(
            color: TColors.greyMy,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: widget.tapCal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.vehicleImg.startsWith('http')
                        ? Image.network(
                            widget.vehicleImg,
                            fit: BoxFit.cover,
                            width: 70,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Image.asset(
                                  TImages.car,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 80,
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            widget.vehicleImg,
                            fit: BoxFit.cover,
                            width: 70,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Image.asset(
                                  TImages.car,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 80,
                                ),
                              );
                            },
                          ),
                  ),
                  // Image(
                  //   image: AssetImage(vehicleImg),
                  //   height: 60,
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend',
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            // ),
          ),
        ),
      ],
    );
  }
}
