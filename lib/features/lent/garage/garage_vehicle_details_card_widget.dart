import 'package:flutter/material.dart';
// import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class GarageVehicleDetailsCardWidgets extends StatefulWidget {
  final String renderImage;
  final String renterName;
  final String vehicleImg;
  final String vehicleName;
  final String ratingText;

  final String statusText;
  final Color statusFgColor;
  final Color statusBgColor;
  final VoidCallback handOverVehicleButton;

  //final VoidCallback paymentTapCall;

  const GarageVehicleDetailsCardWidgets({
    Key? key,
    required this.renderImage,
    required this.renterName,
    required this.vehicleImg,
    required this.vehicleName,
    required this.ratingText,
    required this.statusText,
    required this.statusFgColor,
    required this.statusBgColor,
    required this.handOverVehicleButton,

    //this.paymentTapCall =() => ,
  }) : super(key: key);

  @override
  State<GarageVehicleDetailsCardWidgets> createState() =>
      _GarageVehicleDetailsCardWidgetsState();
}

class _GarageVehicleDetailsCardWidgetsState
    extends State<GarageVehicleDetailsCardWidgets> {
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
                      child: widget.renderImage.startsWith('http')
                          ? Image.network(
                              widget.renderImage,
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
                              widget.renderImage,
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
                          'Rented By',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          widget.renterName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  height: 40,
                  padding: const EdgeInsets.all(2),
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
            const SizedBox(height: 0),
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
                            width: 70,
                            height: 70,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Image.asset(
                                  TImages.car,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            widget.vehicleImg,
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Image.asset(
                                  TImages.car,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // ElevatedBTN(
            //     titleBtn: 'Get back the Vehicle',
            //     onTapCall: widget.handOverVehicleButton),
          ],
        ),
      ),
    );
  }
}
