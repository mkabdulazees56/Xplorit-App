import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/features/Lender_chat/chat_page.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class LendOrdersLentCardWidget extends StatefulWidget {
  final String renterId;
  final String renderImg;
  final String renterName;
  final String vehicleImg;
  final String vehicleName;
  final String vehicleRatingText;
  final String renterRatingText;
  final Timestamp startDate;
  final Timestamp endDate;
  final String statusText;
  final int vehicleNoOfRating;
  final int renterNoOfRating;
  final Color statusFgColor;
  final Color statusBgColor;
  final VoidCallback trackVehicleTapCall;
  final String buttonText;
  final String renterContactNumber;
  //final VoidCallback paymentTapCall;

  const LendOrdersLentCardWidget({
    Key? key,
    required this.renterId,
    required this.renderImg,
    required this.renterName,
    required this.vehicleImg,
    required this.vehicleName,
    required this.vehicleRatingText,
    required this.vehicleNoOfRating,
    required this.renterRatingText,
    required this.renterNoOfRating,
    required this.startDate,
    required this.endDate,
    required this.statusText,
    required this.statusFgColor,
    required this.statusBgColor,
    required this.trackVehicleTapCall,
    required this.buttonText,
    required this.renterContactNumber,
    //this.paymentTapCall =() => ,
  }) : super(key: key);

  @override
  State<LendOrdersLentCardWidget> createState() =>
      _LendOrdersLentCardWidgetState();
}

class _LendOrdersLentCardWidgetState extends State<LendOrdersLentCardWidget> {
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

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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
                          'Rented By',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          widget.renterName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Row(
                          children: [
                            IconTextWidget(
                              icon: Icons.star,
                              txt:
                                  '${widget.renterRatingText} (${widget.renterNoOfRating} Reviews)',
                              colorIcon: Colors.yellow,
                            ),
                          ],
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
                      txt:
                          '${widget.vehicleRatingText} (${widget.vehicleNoOfRating} Reviews)',
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(dateOnPerDay != '' ? Icons.calendar_today : null),
                    Text(
                      dateOnPerDay,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  child: ElevatedBTN(
                    titleBtn: widget.buttonText,
                    onTapCall: widget.trackVehicleTapCall,
                  ),
                ),
                const SizedBox(width: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => chatPage(
                              receiverID: widget.renterId,
                              receiverPhoneNumber: widget.renterContactNumber,
                              displayName: widget.renterName,
                              image: widget.renderImg,
                            ));
                      },
                      icon: Container(
                        width: 30,
                        height: 30,
                        child: Image.asset(TImages.chatIcon),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        _launchDialer(widget.renterContactNumber);
                      },
                      icon: Container(
                        width: 30,
                        height: 30,
                        child: Image.asset(TImages.telephoneIcon),
                      ),
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
