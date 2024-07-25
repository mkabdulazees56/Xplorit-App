// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class VehicleNameTag extends StatefulWidget {
  const VehicleNameTag({
    required this.model,
    required this.rating,
    required this.noOfRating,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  final String model;
  final double rating;
  final int noOfRating;
  final String imageUrl;

  @override
  State<VehicleNameTag> createState() => _VehicleNameTagState();
}

class _VehicleNameTagState extends State<VehicleNameTag> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.model,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 18),
            ),
            SizedBox(height: 10),
            IconTextWidget(
              icon: Icons.star,
              txt: '${widget.rating} (${widget.noOfRating} Reviews)',
              colorIcon: Colors.yellow,
            )
          ],
        ),
        widget.imageUrl.startsWith('http')
            ? Image.network(
                widget.imageUrl,
                height: 100,
                width: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          TImages.car,
                          height: 100,
                          width: 100,
                        ),
                      ],
                    ),
                  );
                },
              )
            : Image.asset(
                widget.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          TImages.car,
                          height: 100,
                          width: 100,
                        ),
                      ],
                    ),
                  );
                },
              ),
        // Image.asset(
        //   TImages.rover,
        //   scale: 8,
        // ),
      ],
    );
  }
}
