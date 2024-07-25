// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class VehicleLabelWidget extends StatelessWidget {
  const VehicleLabelWidget({
    required this.vehicleTitle,
    required this.rating,
    required this.noOfRating,
    required this.distance,
    required this.price,
    required this.vehicleImage,
    required this.onTapCall,
    super.key,
  });
  final String vehicleTitle, distance, price, vehicleImage;
  final double rating;
  final int noOfRating;
  final VoidCallback onTapCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        color: TColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                textAlign: TextAlign.start,
                vehicleTitle,
                style: Theme.of(context).textTheme.headlineMedium?.apply(
                      color: TColors.greyDark,
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      IconTextWidget(
                        icon: Icons.star,
                        txt: '${rating.toString()} ($noOfRating Reviews)',
                      ),
                      IconTextWidget(
                        icon: Icons.location_on,
                        txt: distance,
                      ),
                      IconTextWidget(
                        icon: Icons.sell,
                        txt: price,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  child: vehicleImage.startsWith('http')
                      ? Image.network(
                          vehicleImage,
                          height: 100,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    TImages.car,
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          vehicleImage,
                          height: 100,
                          width: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    TImages.car,
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(), // This will expand to fill the remaining space
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onTapCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Rent Now',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
