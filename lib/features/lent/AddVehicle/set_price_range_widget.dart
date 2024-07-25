// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class SetPriceRangeWidget extends StatefulWidget {
  const SetPriceRangeWidget({
    required this.division,
    required this.priceTitle,
    required this.minimumPrice,
    required this.maximumPrice,
    required this.initialHigherPrice,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final int division;
  final String priceTitle;
  final double minimumPrice;
  final double maximumPrice;
  final double initialHigherPrice;
  final Function(double) onChanged;

  @override
  _SetPriceRangeWidgetState createState() => _SetPriceRangeWidgetState();
}

class _SetPriceRangeWidgetState extends State<SetPriceRangeWidget> {
  late int higherPrice;

  @override
  void initState() {
    super.initState();
    higherPrice = widget.initialHigherPrice.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: double.minPositive,
          decoration: BoxDecoration(
            border: Border.all(color: TColors.primary, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              widget.priceTitle,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Slider(
                            divisions: widget.division,
                            value: higherPrice.toDouble().clamp(
                                widget.minimumPrice, widget.maximumPrice),
                            min: widget.minimumPrice.toDouble(),
                            max: widget.maximumPrice.toDouble(),
                            activeColor: TColors.primary,
                            inactiveColor: TColors.blueLight,
                            onChanged: (double newValue) {
                              setState(() {
                                higherPrice = newValue.toInt();
                              });
                              widget.onChanged(newValue);
                            },
                          ),

                          // Slider(
                          //   divisions: widget.division,
                          //   value: higherPrice.toDouble(),
                          //   min: widget.minimumPrice,
                          //   max: widget.maximumPrice,
                          //   // divisions:
                          //   //     (widget.maximumPrice - widget.minimumPrice) ~/
                          //   //         10,
                          //   activeColor: TColors.primary,
                          //   inactiveColor: TColors.blueLight,
                          //   onChanged: (double newValue) {
                          //     setState(() {
                          //       higherPrice = newValue.toInt();
                          //     });
                          //     widget.onChanged(newValue);
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 1.0, color: TColors.primary),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              '$higherPrice',
                              style: TextStyle(fontSize: 20),
                              // style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 25),
                            child: Text(
                              'pkr',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
