import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/common_widgets/order_summery_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';

class LendOrdersCompletedCardWidget extends StatefulWidget {
  final String renderImg;
  final String renterName;
  final String vehicleImg;
  final String vehicleName;
  final String ratingText;
  final Timestamp endDate;
  final String statusText;
  final Color statusFgColor;
  final Color statusBgColor;
  final String rentalRateType;
  final int rentalDuration;

  const LendOrdersCompletedCardWidget({
    Key? key,
    required this.renderImg,
    required this.renterName,
    required this.vehicleImg,
    required this.vehicleName,
    required this.ratingText,
    required this.endDate,
    required this.statusText,
    required this.statusFgColor,
    required this.statusBgColor,
    required this.rentalRateType,
    required this.rentalDuration,
  }) : super(key: key);

  @override
  State<LendOrdersCompletedCardWidget> createState() =>
      _LendOrdersCompletedCardWidgetState();
}

class _LendOrdersCompletedCardWidgetState
    extends State<LendOrdersCompletedCardWidget> {
  String endDate = '';

  @override
  void initState() {
    super.initState();
    endDate = widget.endDate.toDate().toString();
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.renderImg.startsWith('http')
                          ? Image.network(
                              widget.renderImg,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
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
                              width: 70,
                              height: 70,
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
                          widget.renterName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  width: 100,
                  height: 40,
                  padding: EdgeInsets.all(2),
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.vehicleName,
                      style: Theme.of(context).textTheme.bodyLarge,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    Text(
                      endDate,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            OrderSummery(
              rentalRateType: widget.rentalRateType,
              noOfDays: widget.rentalDuration,
              rentalRate: 1000,
            ),
          ],
        ),
      ),
    );
  }
}
