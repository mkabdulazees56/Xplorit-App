// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xplorit/features/product/features_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';

class OrderSummery extends StatefulWidget {
  const OrderSummery({
    required this.rentalRate,
    required this.rentalRateType,
    required this.noOfDays,
    Key? key,
  }) : super(key: key);

  final double rentalRate;
  final String rentalRateType;
  final int noOfDays;

  @override
  State<OrderSummery> createState() => _OrderSummeryState();
}

class _OrderSummeryState extends State<OrderSummery> {
  double total = 0.0;
  String durationType = '';

  @override
  void initState() {
    super.initState();
    total = widget.rentalRate * widget.noOfDays;
    if (widget.rentalRateType == 'Per day') {
      durationType = 'day(s)';
    } else {
      durationType = 'hour(s)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
            color: TColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              'My Order Summery',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.apply(color: TColors.white),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: TColors.blueLight,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FeaturesWidget(
                    title1: 'Rent ${widget.rentalRateType}',
                    title2: '${widget.rentalRate} PKR'),
                const SizedBox(height: 5),
                FeaturesWidget(
                    title1: 'Duration',
                    title2: '${widget.noOfDays}  $durationType'),
                const SizedBox(height: 5),
                FeaturesWidget(
                    title1: 'Total',
                    title2: '${(widget.rentalRate * widget.noOfDays)} PKR'),
                const SizedBox(height: 5),
              ],
            ),
          ),
        )
      ],
    );
  }
}
