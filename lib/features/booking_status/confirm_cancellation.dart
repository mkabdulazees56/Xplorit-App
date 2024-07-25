// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class ConfirmCancelBooking extends StatefulWidget {
  const ConfirmCancelBooking({Key? key}) : super(key: key);
  @override
  State<ConfirmCancelBooking> createState() => _ConfirmCancelBooking();
}

class _ConfirmCancelBooking extends State<ConfirmCancelBooking> {
  int bottomNavBarCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    void showAlert(BuildContext context) {
      QuickAlert.show(
        context: context,
        title: 'Success',
        text: 'Booking has been canceled successfully. Thank you.',
        type: QuickAlertType.success,
        confirmBtnColor: TColors.primary,
        confirmBtnText: 'Back to Home',
        onConfirmBtnTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
            (Route<dynamic> route) => false,
          );
        },
      );
    }

    Future<bool> showCancelDialog(context) async {
      return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'Are you sure you want to cancel the booking?',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: 120,
                          child: ElevatedBTN(
                              titleBtn: 'Yes',
                              onTapCall: () {
                                showAlert(context);
                              },
                              btnColor: Colors.red)),
                      SizedBox(
                        width: 120,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            'No',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                BackButtonWidget(),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Are you sure you want to cancel the booking?',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 35),
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
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDE3B40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'You will receive a refund amount equal to 50% of the subtotal and a full refund of the refundable deposit if the payment was made online.',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.apply(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedBTN(
                  titleBtn: "Confirm Cancellation",
                  onTapCall: () {
                    showCancelDialog(context);
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
