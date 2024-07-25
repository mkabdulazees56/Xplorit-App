import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class TrackVehicleCardWidget extends StatefulWidget {
  final String renderImg;
  final String renterName;
  final String vehicleImg;
  final String vehicleName;
  final double imgScale;

  const TrackVehicleCardWidget({
    Key? key,
    required this.renderImg,
    required this.renterName,
    required this.vehicleImg,
    required this.vehicleName,
    required this.imgScale,
  }) : super(key: key);

  @override
  State<TrackVehicleCardWidget> createState() => _TrackVehicleCardWidgetState();
}

class _TrackVehicleCardWidgetState extends State<TrackVehicleCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: TColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.vehicleName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: widget.renderImg.startsWith('http')
                            ? Image.network(
                                widget.renderImg,
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
                                widget.renderImg,
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
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rented By",
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
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
