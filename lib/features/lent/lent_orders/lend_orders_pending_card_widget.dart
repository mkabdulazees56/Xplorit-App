import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';

class LendOrdersPendingCardWidget extends StatefulWidget {
  final String renderImg;
  final double renderImgScale;
  final String renterName;
  final String vehicleImg;
  final String vehicleName;
  final String ratingText;
  final String idText;
  final double imgScale;
  final String startDate;
  final String endDate;
  final String statusText;
  final Color statusFgColor;
  final Color statusBgColor;
  final VoidCallback trackVehicleTapCall;
  final String buttonText;
  //final VoidCallback paymentTapCall;

  const LendOrdersPendingCardWidget({
    Key? key,
    required this.renderImg,
    required this.renderImgScale,
    required this.renterName,
    required this.vehicleImg,
    required this.vehicleName,
    required this.ratingText,
    required this.idText,
    required this.imgScale,
    required this.startDate,
    required this.endDate,
    required this.statusText,
    required this.statusFgColor,
    required this.statusBgColor,
    required this.trackVehicleTapCall,
    required this.buttonText,
    //this.paymentTapCall =() => ,
  }) : super(key: key);

  @override
  State<LendOrdersPendingCardWidget> createState() =>
      _LendOrdersPendingCardWidgetState();
}

class _LendOrdersPendingCardWidgetState
    extends State<LendOrdersPendingCardWidget> {
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
                    IconTextWidget(icon: Icons.numbers, txt: widget.idText),
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
                      widget.startDate,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    Text(
                      widget.endDate,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 230,
                  child: ElevatedBTN(
                    titleBtn: widget.buttonText,
                    onTapCall: widget.trackVehicleTapCall,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedBTN(
                    titleBtn: 'Decline',
                    onTapCall: widget.trackVehicleTapCall,
                    btnColor: TColors.accent,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
