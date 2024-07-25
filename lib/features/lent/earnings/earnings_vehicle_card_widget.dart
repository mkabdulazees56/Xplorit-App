// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class EarningsVehicleCardWidgets extends StatefulWidget {
  const EarningsVehicleCardWidgets({
    required this.startDate,
    required this.endDate,
    required this.vehicleImg,
    required this.vehicleName,
    required this.renderImg,
    required this.renderImgScale,
    required this.earning,
    required this.renterName,
    Key? key,
  }) : super(key: key);

  final Timestamp startDate;
  final Timestamp endDate;
  final String vehicleImg;
  final String vehicleName;
  final String renderImg;
  final double renderImgScale;
  final double earning;
  final String renterName;

  @override
  State<EarningsVehicleCardWidgets> createState() =>
      _EarningsVehicleCardWidgetsState();
}

class _EarningsVehicleCardWidgetsState
    extends State<EarningsVehicleCardWidgets> {
  String startDate = '';
  String endDate = '';
  String dateOnPerDay = '';

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate.toDate().toString().split(' ')[0];
    endDate = widget.endDate.toDate().toString().split(' ')[0];
    if (startDate == endDate) {
      dateOnPerDay = startDate;
      startDate =
          '${widget.startDate.toDate().hour.toString().padLeft(2, '0')}:${widget.startDate.toDate().minute.toString().padLeft(2, '0')}';
      endDate =
          '${widget.endDate.toDate().hour.toString().padLeft(2, '0')}:${widget.endDate.toDate().minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TColors.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vehicleName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 10),
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
                                return Center(
                                    child: Image.asset(
                                  TImages.car,
                                  fit: BoxFit.cover,
                                ));
                              },
                            )
                          : Image.asset(
                              widget.vehicleImg,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                    child: Image.asset(
                                  TImages.car,
                                  fit: BoxFit.cover,
                                ));
                              },
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height:
                      10), // Add some spacing between the vehicle details and the date rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      Text(
                        startDate,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      Text(
                        endDate,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: widget.renderImg.startsWith('http')
                        ? Image.network(
                            widget.renderImg,
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
                            widget.renderImg,
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
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rented By',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        widget.renterName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text('Rs. ${widget.earning}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
