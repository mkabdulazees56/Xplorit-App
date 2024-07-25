// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/features/lent/AddVehicle/add_car_details_form.dart';
import 'package:xplorit/features/lent/AddVehicle/select_vehicle_type_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class SelectVehicleType extends StatefulWidget {
  const SelectVehicleType({Key? key}) : super(key: key);

  @override
  State<SelectVehicleType> createState() => _SelectVehicleTypeState();
}

class _SelectVehicleTypeState extends State<SelectVehicleType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: TColors.primary,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(
                  btnColor: TColors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select your types of vehicle',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: TColors.white,
                              ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Before continuing we want to know what kind of vehicle you want to lend',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.normal, fontFamily: 'Manrope'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectVehicleTypeWidget(
                          title: "Car",
                          iconImg: TImages.car,
                          tapCal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddCarDetails(vehicleType: 'car')),
                            );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SelectVehicleTypeWidget(
                          title: "Rickshaw",
                          iconImg: TImages.rickshaw,
                          tapCal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddCarDetails(vehicleType: 'rickshaw')),
                            );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SelectVehicleTypeWidget(
                          title: "Motor Bike",
                          iconImg: TImages.motorBike,
                          tapCal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddCarDetails(vehicleType: 'motor bike')),
                            );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SelectVehicleTypeWidget(
                          title: "Bicycle",
                          iconImg: TImages.bicycle,
                          tapCal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddCarDetails(vehicleType: 'bicycle')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
