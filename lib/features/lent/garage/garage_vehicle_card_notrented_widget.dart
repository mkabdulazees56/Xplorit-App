import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class GarageVehicleDetailsNotCardWidgets extends StatefulWidget {
  final String vehicleImg;
  final String vehicleName;
  final String ratingText;
  // final String idText;
  // final double imgScale;
  final String statusText;
  final Color statusFgColor;
  final Color statusBgColor;
  final VoidCallback removeVehicleButton;

  const GarageVehicleDetailsNotCardWidgets({
    Key? key,
    required this.vehicleImg,
    required this.vehicleName,
    required this.ratingText,
    // required this.idText,
    // required this.imgScale,
    required this.statusText,
    required this.statusFgColor,
    required this.statusBgColor,
    required this.removeVehicleButton,
  }) : super(key: key);

  @override
  State<GarageVehicleDetailsNotCardWidgets> createState() =>
      _GarageVehicleDetailsNotCardWidgetsState();
}

class _GarageVehicleDetailsNotCardWidgetsState
    extends State<GarageVehicleDetailsNotCardWidgets> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
          color: TColors.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.vehicleName,
                    style: Theme.of(context).textTheme.bodyLarge,
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
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconTextWidget(
                        icon: Icons.star,
                        txt: widget.ratingText,
                        colorIcon: Colors.yellow,
                      ),
                      // IconTextWidget(icon: Icons.numbers, txt: idText),
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
                              width: 100,
                              height: 100,
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
                              width: 100,
                              height: 100,
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
                  )
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: TColors.accent),
                  onPressed: widget.removeVehicleButton,
                  child: const Text('Remove the vehicle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
