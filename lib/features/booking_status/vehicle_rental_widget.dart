// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';

class VehicleRentalWidget extends StatefulWidget {
  final String lenderImg;
  final String lender;
  final String lenderLocation;
  final String vehicleImg;
  final String vehicleName;
  final String ratingText;
  final String statusText;
  final Timestamp startDate;
  final Timestamp endDate;
  final Color statusFgColor;
  final Color statusBgColor;

  VehicleRentalWidget({
    Key? key,
    required this.lenderImg,
    required this.lender,
    required this.lenderLocation,
    required this.vehicleImg,
    required this.vehicleName,
    required this.ratingText,
    this.statusText = '',
    this.statusFgColor = TColors.secondary,
    this.statusBgColor = TColors.secondary,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<VehicleRentalWidget> createState() => _VehicleRentalWidgetState();
}

class _VehicleRentalWidgetState extends State<VehicleRentalWidget> {
  String startDate = '';
  String endDate = '';

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate.toDate().toString().split(' ')[0];
    endDate = widget.endDate.toDate().toString().split(' ')[0];

    if (startDate == endDate) {
      startDate =
          '${widget.startDate.toDate().hour.toString().padLeft(2, '0')}:${widget.startDate.toDate().minute.toString().padLeft(2, '0')}';
      endDate =
          '${widget.endDate.toDate().hour.toString().padLeft(2, '0')}:${widget.endDate.toDate().minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // CircleAvatar(
                      //   radius: 25,
                      //   backgroundImage: Image.asset(widget.lenderImg).image,
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: widget.lenderImg.startsWith('http')
                            ? Image.network(
                                widget.lenderImg,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: TColors.secondary,
                                      size: 60,
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                widget.lenderImg,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: TColors.secondary,
                                      size: 60,
                                    ),
                                  );
                                },
                              ),
                        // Image.asset(renderImg, scale: renderImgScale).image,
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.lender,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  height: 50,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.statusBgColor,
                  ),
                  child: Center(
                    child: Text(
                      widget.statusText,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.apply(color: widget.statusFgColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              widget.lenderLocation,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.vehicleName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    IconTextWidget(
                      icon: Icons.star,
                      txt: widget.ratingText,
                      colorIcon: Colors.yellow,
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: widget.vehicleImg.startsWith('http')
                        ? Image.network(
                            widget.vehicleImg,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.person,
                                  color: TColors.secondary,
                                  size: 60,
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            widget.vehicleImg,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.person,
                                  color: TColors.secondary,
                                  size: 60,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    Text(
                      startDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    Text(
                      endDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
