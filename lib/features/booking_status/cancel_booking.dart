// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/order_summery_widget.dart';
import 'package:xplorit/features/booking_status/confirm_cancellation.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class CancelBooking extends StatefulWidget {
  const CancelBooking({Key? key}) : super(key: key);
  @override
  State<CancelBooking> createState() => _CancelBooking();
}

class _CancelBooking extends State<CancelBooking> {
  int bottomNavBarCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonWidget(),
                const SizedBox(height: 5),
                Text(
                  'Cancel Booking',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                // VehicleRentalWidget(
                //   lenderImg: TImages.mountainBike,
                //   lender: "Manawala Rentals",
                //   lenderLocation: "Manawala",
                //   vehicleImg: TImages.mahendiraThar,
                //   vehicleName: "Mahendira Thar",
                //   ratingText: "4.9 (531 reviews)",
                //   startDate: '1/1/2024',
                //   endDate: '1/23/2024',
                // ),
                OrderSummery(
                  rentalRateType: 'Per day',
                  noOfDays: 5,
                  rentalRate: 1000,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedBTN(
                  titleBtn: 'Cancel Booking',
                  onTapCall: () {
                    Get.to(ConfirmCancelBooking());
                  },
                  btnColor: Colors.red,
                )
              ],
            ),
          ), //main Column
        ),
      ),
    );
  }
}
